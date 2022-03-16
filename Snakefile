########### Snakefile créer par Yascim Kamel dans le cadre de son stage de master 2 à l'Université de Montpellier #########################
###########################################################################################################################################
#######          Les versions des outils ici utilisés sont : -busco v5.2.2                                              ###################
#######                                                      -augustus v3.3.3                                           ###################
#######                                                      -bedtools v2.27.1                                          ###################
#######                                                                                                                 ###################
###########################################################################################################################################
###########################################################################################################################################



## La liste ci-dessous correspond à la liste des espèce et des différentes bases de données utilisées. IL est possible d'ajouter
## des espèces et bases de données, cependant les espèces listées doivent se trouver dans toute les bases de données.


ESPECES=["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae"]
liste_BD = ["DNAZoo", "NCBI"]



## Cette règle contient en entrée le dernier fichier généré par le pipeline. Il permet d'automatiser le lancement de ce dernier.
rule all:
        input:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/final.txt"


#rule copy : ### Permet de donneesr les génomes
#	input: 
#	       "/media/newvol/yascimkamel/Pipeline/genome/donnees/{espece}/{espece}_{BD}.fasta" 
#	output:
#             "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_donneesd.fasta"
#	shell:
#                "cp {input} {output} "

#rule read: # Permet d'indiquer dans un fichier txt le nombre de ligne pour un assemblage
#        input :
#                expand("/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_donneesd.fasta", espece=ESPECES,BD=liste_BD)
#        output :
#                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/count_ligne_number.txt"
#        shell:
#                "wc -l {input} > {output}"


### run_busco permet de calculer le score Busco grâce à l'outil du même nom. Ce score permet d'évaluer l'intégralité d'un génome au format fasta.  
## Les tests ont été effectué sur busco v5.2.2. 
rule run_busco:
    input:
        "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}.fasta"
    output:
        directory("{espece}_{BD}_busco")
    log:
        "logs/quality/genome_{espece}_{BD}_busco.log"
    threads: 8
    shell:
        "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 "



## Une règle busco a été ajoutée à la règle précédente pour permettre d'automatisé le lancement du calcul précédent. 
## Il génére en sortie un fichier txt contenant tous les log générés. 
rule busco :
        input : 
                expand("logs/quality/genome_{espece}_{BD}_busco.log", espece=ESPECES, BD=liste_BD)
        output: 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/log_merged.txt"
        shell : 
                "echo {input} > {output}"




### Cette règle permet d'utiliser l'outil augustus. C'est un outil ab initio qui génére un fichier au format gff contenant les coordonées génomiques 
### des gènes potentiels contenu dans un génome au format fasta.
rule augustus :
        input : 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/sortie_augustus/{espece}_{BD}.gff"
        shell : 
                "augustus --species=human  {input} > {output}"



### la fonction getfasta de bedtools permet de croiser un fichier des fichiers au format fasta et gff afin de pouvoir extraire les portions génomiques
### correspondantes au format fasta. Cette étape est nécessaire en vu de l'utilisation du prochain outil. 

rule bedtools : 
        input: 
                fasta="/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}.fasta", 
                gff="/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/sortie_augustus/{espece}_{BD}.gff"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/sortie_bedtools/{espece}_{BD}_OR.fasta"
        shell: 
                "bedtools getfasta "
                "-fo {output} "
                "-fi {input.fasta} "
                "-bed {input.gff}"
rule fin : 
        input :
                expand("/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/sortie_bedtools/{espece}_{BD}_OR.fasta", espece=ESPECES,BD=liste_BD),
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/log_merged.txt"
        output: 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/final.txt"
        shell : 
                "echo 'les fichiers suivants ont été générés \n' > {output} | echo {input} >> {output}"


## ORA est un outil permettant d'identifier les gènes étant des gènes Olfactif. Il utilise en entrée un fichier fasta. 
rule ORA:
        input:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_OR.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/recapitulatif.csv"
        shell : 
                "or.pl --format=csv --sequence={input}"




################################################################# Rules abandonnées ############################################################## 

## Permet de lire un fichier csv en utilisant un script python 
#rule read_csv : 
#       input: 
#               "données/données.csv"
#       output: 
#               "données.txt"
#       shell: 
#               "python3 recup_lien.py {input} > {output}"



## Le but de cette régle était de récupéré automatiquement les noms des espèces et bases de données directement dans un fichier au format CSV 
#rule name_recuperation :
#	input: "/media/newvol/yascimkamel/genome/{espece}"
#	output: 
#		{espece}_{BD}{espece}.txt"
#	shell:
#		"ls {input} >{espece}_{BD}{wildcards.espece}.txt " 
