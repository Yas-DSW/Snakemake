
ESPECES=["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae"]
liste_BD = ["DNAZoo", "NCBI"]


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


rule run_busco:
    input:
        "/media/newvol/yascimkamel/Pipeline/genome/donnees/{espece}/{espece}_{BD}.fasta"
    output:
        directory("{espece}_{BD}_busco")
    log:
        "logs/quality/genome_{espece}_{BD}_busco.log"
    threads: 8
    shell:
        "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 "


rule busco :
        input : 
                expand("logs/quality/genome_{espece}_{BD}_busco.log", espece=ESPECES, BD=liste_BD)
        output: 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/log_merged.txt"
        shell : 
                "echo input > {output}"


rule augustus :
        input : 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/sortie_augustus/{espece}_{BD}.gff"
        shell : 
                "augustus --species=human  {input} > {output}"


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
                expand("/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/sortie_bedtools/{espece}_{BD}_OR.fasta", espece=ESPECES,BD=liste_BD)
        output: 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/final.txt"
        shell : 
                "echo 'les fichiers suivants ont été générés \n' > {output} | echo {input} >> {output}"

rule ORA:
        input:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_OR.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/recapitulatif.csv"
        shell : 
                "or.pl --format=csv --sequence={input}"

# rule read: # Permet d'indiquer dans un fichier txt le nombre de ligne pour un assemblage
#         input :
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_donneesd.fasta"
#         output :
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/read/{espece}_{BD}_ligne_number.txt"
#         shell:
#                 "wc -l {input} > {output}"


# rule busco :
#         input:
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_donneesd.fasta"
#         output:
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_BUSCO"
#         shell: 
#                 "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 --cpu=8"





################################################################# Rules abandonnées ############################################################## 

#rule read_csv : 
#       input: 
#               "données/données.csv"
#       output: 
#               "données.txt"
#       shell: 
#               "python3 recup_lien.py {input} > {output}"

#rule name_recuperation :
#	input: "/media/newvol/yascimkamel/genome/{espece}"
#	output: 
#		{espece}_{BD}{espece}.txt"
#	shell:
#		"ls {input} >{espece}_{BD}{wildcards.espece}.txt " 


#rule copy_DNA : 
#	input: 
#		"/media/newvol/yascimkamel/Pipeline/genome/{espece}/{espece}_{BD}DNAZoo.fasta",
#	output:
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}DNAZoo.fasta"
#	shell:
#		"cp {input} {output}"

#rule copy_NCBI :
#        input:
#                "/media/newvol/yascimkamel/Pipeline/genome/{espece}/{espece}_{BD}NCBI.fna"
#        output:
#                "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}NCBI.fna"
#        shell:
#                "cp {input} {output}"

#rule uncompress :
#	input: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}.gz"
#	output: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{assemblage}"
#	shell: 
#		"unzip {input}"


#rule read_NCBI: 
#	input : 
#		"/media/newvol/yascimkamel/Pipeline/genome/{espece}/{espece}_{BD}NCBI.fasta"
#	output :
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{espece}_{BD}NCBI_read.txt" 
#	shell: 
#		"wc -l {input} > {output}"


#rule read_DNA:
 #       input :
  #              "/media/newvol/yascimkamel/Pipeline/genome/{espece}/{espece}_{BD}DNAZoo.fasta"
  #      output :
  #              "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/read/{espece}_{BD}DNAZoo_read.txt"
   #     shell:
    #            "wc -l {input} > {output}"




    #rule merge_read:
#	    input :
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/read/{espece}_{BD}DNAZoo_read.txt",
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{espece}_{BD}NCBI_read.txt"
#	    output :
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{espece}_{BD}all_read.txt"
#	    shell:
#	            "cat{input} >> {output}"
#	            "rm {input}"

# rule busco_line :
#         input:
#                 "/media/newvol/yascimkamel/Pipeline/genome/donnees/{espece}/{espece}_{BD}.fasta"
#         output:
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_BUSCO"

#         shell: 
#                 "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 --cpu= 8"

# rule busco_line :
#         input:
#                 "/media/newvol/yascimkamel/Pipeline/genome/donnees/{espece}/{espece}_{BD}.fasta"
#         output:
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/donnees/{espece}/{espece}_{BD}_BUSCO"

#         shell: 
#                 "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 --cpu= 8"