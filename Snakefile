########### Snakefile créer par Yascim Kamel dans le cadre de son stage de master 2 à l'Université de Montpellier #########################
###########################################################################################################################################
#######          Les versions des outils ici utilisés sont : -busco v5.2.2                                              ###################
#######                                                      -augustus v3.3.3                                           ###################
#######                                                      -bedtools v2.27.1                                          ###################
#######                                                                                                                 ###################
###########################################################################################################################################
###########################################################################################################################################
from Bio import SeqIO
import csv
import re
import glob
import psycopg2

## La liste ci-dessous correspond à la liste des espèce et des différentes bases de données utilisées. IL est possible d'ajouter
## des espèces et bases de données, cependant les espèces listées doivent se trouver dans toute les bases de données.





configfile="config.yaml"
files_paths_list= glob.glob(config["genomes_directory_path"] + "/*.fa")

files_list=[]
for paths in list:
        file_name=re.sub.(config["genomes_directory_path"]+"/", '', paths)
        files_list.append(file_name)


# ESPECES=["Globicephala_melas"]
# # "Tursiop_truncatus","Megaptera_novaeangliae"]
# liste_BD = ["DNAZoo","NCBI"]

## Cette règle contient en entrée le dernier fichier généré par le pipeline. Il permet d'automatiser le lancement de ce dernier.
rule all:
        input:
                expand("sorties/{espece}/complete_{espece}_{genre}_{BD}_{assemblie}_{score_busco}", espece=config[files_list]["Specie"],
                        genre=config[files_list]["Genre"], BD=config[files_list]["BD"], assemblie=config[files_list]["Assemblie_name"])
                # expand("sorties/{espece}/ORA/{espece}_{BD}_OR_list.fa", espece=ESPECES,BD=liste_BD),
                expand("{espece}_{BD}_busco/run_cetartiodactyla_odb10/short_summary.txt", espece=ESPECES,BD=liste_BD),
                "../donnees/gene_completed.csv"


### run_busco permet de calculer le score Busco grâce à l'outil du même nom. Ce score permet d'évaluer l'intégralité d'un génome au format fasta.  
## Les tests ont été effectué sur busco v5.2.2. 
rule run_busco:
        input:
                "../donnees/{espece}_{BD}.fasta"
        output:
        temp(directory("sorties/{espece}/score_busco/{espece}_{BD}_busco"))
        params:
                directory = "{espece}_{BD}_busco"  
        #log:
        #        "logs/quality/genome_{espece}_{BD}_busco.log"
        threads: 8 
        shell:
                "busco -f -m genome -i {input} -o {params.directory} -l cetartiodactyla_odb10"



## Une règle busco a été ajoutée à la règle précédente pour permettre d'automatiser le lancement du calcul précédent. 
## Elle génére en sortie un fichier txt contenant tous les log générés. 
#rule busco :
#        input : 
#                expand("sorties/{espece}/score_busco/{espece}_{BD}_busco/short_summary.specific.cetartiodactyla_odb10.sortie.txt", espece=ESPECES, BD=liste_BD)
#        output: 
#                "sorties/log_merged_busco.txt"
#        shell : 
#                "echo {input} > {output}"




### Cette règle permet d'utiliser l'outil augustus. C'est un outil ab initio qui génère un fichier au format gff contenant les coordonées génomiques 
### des gènes potentiels contenu dans un génome au format fasta.
rule augustus :
        input : 
                "../donnees/{espece}/{espece}_{BD}.fasta"
        output:
                temp("sorties/{espece}/augustus/{espece}_{BD}.gff")
        # conda : 
        #         "envs/augustus.yaml" 
        shell : 
                "augustus --species=human  {input} > {output}"

rule augustus_only_gene : 
        input :
                "sorties/{espece}/augustus/{espece}_{BD}.gff"
        output:
                "sorties/{espece}/augustus/{espece}_{BD}_genes.gff"
        shell : 
                "python3 extraction_line.py {input}"



### la fonction getfasta de bedtools permet de croiser des fichiers au format fasta et gff afin de pouvoir extraire les portions génomiques
### correspondantes au format fasta. Cette étape est nécessaire en vue de l'utilisation du prochain outil. 

rule bedtools : 
        input: 
                fasta="../donnees/{espece}/{espece}_{BD}.fasta", 
                gff="sorties/{espece}/augustus/{espece}_{BD}_genes.gff"
        output:
                temp("sorties/{espece}/bedtools/{espece}_{BD}_OR.fasta")
        # conda : 
        #         "envs/bedtools.yaml" 
        shell: 
                "bedtools getfasta "
                "-fo {output} "
                "-fi {input.fasta} "
                "-bed {input.gff}"
rule split:
        input:
                "sorties/{espece}/bedtools/{espece}_{BD}_OR.fasta"
        output: 
                temp("sorties/{espece}/bedtools/{espece}_{BD}_OR_lower_length.fasta",)
                "sorties/{espece}/bedtools/{espece}_{BD}_OR_superior_length.fasta"

        run: 
                with open(input[0],"r") as fasta_file :
                        with open (output[0],"w") as sortie:
                                with open (output[1],"w") as output_alternative:
                                        for record in SeqIO.parse(fasta_file,"fasta"): 
                                                if len(record.seq)<= 2500:
                                                        sortie.write('>'+ str(record.id)+'\n'+ str(record.seq)+ '\n')
                                                else:
                                                        output_alternative.write('>'+ str(record.id)+'\n'+ str(record.seq)+ '\n')


## ORA est un outil permettant d'identifier les gènes étant des gènes olfactifs. Il utilise en entrée un fichier fasta. 
rule ORA:
        input:
                "sorties/{espece}/bedtools/{espece}_{BD}_OR_lower_length.fasta"
        output:
                "sorties/{espece}/{espece}_{BD}_OR_list.fa"
        shell : 
                "or.pl --sequence={input} > {output}"




########## Ajout de l'expérience à la base de données  ################

connect = psycopg2.connect("dbname=cegec user='postgres' host='localhost' port='5433'")
nouvel_experience="INSERT INTO experience (pipeline) VALUES ('Pipeline de Yascim')"
cur=connection.cursor()
cur.execute(nouvel_experience)
connection.commit()

######## Récupération de l'identifiant généré ####################
recup_experience="SELECT max(id) from experience;"

cur.execute(recup_experience)
ID_experience=cur.fetchall()




### Cette règle permet de modifier le CSV d'entrée pour qu'il soit rempli après.

rule complete_BD :
        input:  
                multifasta="sorties/{espece}/bedtools/{espece}_{BD}_OR_lower_length.fasta",

        output:
                temp("sorties/{espece}/complete_{espece}_{genre}_{BD}_{assemblie}_{score_busco}")

        shell :
                "python3  multifasta_to_bd.py {espece}_{genre} {BD} {score_busco} {multifasta} {assemblie} {ID_experience} "






 


# rule gene_number: 
#         input:>
#                 "sorties/{espece}/ORA/{espece}_{BD}_OR_list.fa"
#         output:
#                 "sorties/{espece}/ORA/{espece}_{BD}_gene_OR_number.txt
#         shell : 
#                 "echo 'Le pipeline a détécté : \n' > {output} | "
#                 "grep -c '>' {input} >> {output} | "
#                 "echo '\n' >> {output}" 

# rule fausse_fin : 
#         input :
#                 expand("sorties/{espece}/ORA/{espece}_{BD}_gene_OR_number.txt", espece=ESPECES,BD=liste_BD),
#                 "sorties/log_merged_busco.txt"
#         output: 
#                 "../donnees/final.txt"
#         shell : 
#                 "echo 'les fichiers suivants ont été générés \n' > {output} | echo {input} >> {output} | echo '\n' >> {output}"

##### Rules permettznt de remplir le CSV cavec les nombres de gènes et le score busco. 

# # rule remplit_CSV : 
# #         input : 
# #                 tableau="/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/données_modified.csv", 
#                   nb_gene="/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/recapitulatif.csv",
#                   score_busco="{espece}_{BD}_busco/short_summary.specific.cetartiodactyla_odb10.{espece}_{BD}_busco.txt"
# #         output : 
# #                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/sortie.csv"
# #         shell: 
# #                 ""



################################################################# Rules abandonnées ############################################################## 

## Permet de lire un fichier csv en utilisant un script python 
#rule read_csv : 
#       input: 
#               "données/données.csv"
#       output: 
#               "données.txt"
#       shell: 
#               "python3 recup_lien.py {input} > {output}"

#rule copy : ### Permet de donneesr les génomes
#       input: 
#              "/media/newvol/yascimkamel/Pipeline/genome/donnees/{espece}/{espece}_{BD}.fasta" 
#       output:
#             "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_donneesd.fasta"
#       shell:
#                "cp {input} {output} "

#rule read: # Permet d'indiquer dans un fichier txt le nombre de ligne pour un assemblage
#        input :
#                expand("/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_donneesd.fasta", espece=ESPECES,BD=liste_BD)
#        output :
#                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/count_ligne_number.txt"
#        shell:
#                "wc -l {input} > {output}"

## Le but de cette régle était de récupéré automatiquement les noms des espèces et bases de données directement dans un fichier au format CSV 
#rule name_recuperation :
#	input: "/media/newvol/yascimkamel/genome/{espece}"
#	output: 
#		{espece}_{BD}{espece}.txt"
#	shell:
#		"ls {input} >{espece}_{BD}{wildcards.espece}.txt " 
