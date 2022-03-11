
#rule read_csv : 
#	input: 
#		"données/données.csv"
#	output: 
#		"données.txt"
#	shell: 
#		"python3 recup_lien.py {input} > {output}"
ESPECES=["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae"]
liste_BD = ["DNAZoo", "NCBI"]


rule all:
        input:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/busco_clear.txt"


#rule copy : ### Permet de copier les génomes
#	input: 
#	       "/media/newvol/yascimkamel/Pipeline/genome/copie/{espece}/{espece}_{BD}_f.fasta" 
#	output:
#             "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_copied.fasta"
#	shell:
#                "cp {input} {output} "

#rule read: # Permet d'indiquer dans un fichier txt le nombre de ligne pour un assemblage
#        input :
#                expand("/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_copied.fasta", espece=ESPECES,BD=liste_BD)
#        output :
#                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/count_ligne_number.txt"
#        shell:
#                "wc -l {input} > {output}"


rule busco :
        input:
                expand("/media/newvol/yascimkamel/Pipeline/genome/copie/{espece}/{espece}_{BD}_f.fasta", espece=ESPECES,BD=liste_BD)
        output:
#"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_BUSCO"
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/busco_clear.txt"
        shell: 
                "busco -m genome -i {input} -o /media/newvol/yascimkamel/Pipeline/Snakemake/copie/{wildcard.espece}/{wildcard.espece}_{wildcard.BD}_BUSCO -l cetartiodactyla_odb10 --cpu=8"
                "echo 'analyse busco effectuée' >> {output}"

rule augustus :
        input : 
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_f.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}.gff"
        shell : 
                "augustus --species=human  {input} > {output}"


rule bedtools : 
        input: 
                fasta="/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_copied.fasta", 
                gff="/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}.gff"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_OR.fasta"
        shell: 
                "bedtools getfasta -fo /media/newvol/yascimkamel/Pipeline/Snakemake/copie/{wildcard.espece}/{wildcard.espece}_{woldcard.BD}_OR.fasta -fi {fasta} -bed {gff} "

rule ORA:
        input:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_OR.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/recapitulatif.csv"
        shell : 
                "or.pl --format=csv --sequence={input}"

# rule read: # Permet d'indiquer dans un fichier txt le nombre de ligne pour un assemblage
#         input :
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_copied.fasta"
#         output :
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/read/{espece}_{BD}_ligne_number.txt"
#         shell:
#                 "wc -l {input} > {output}"


# rule busco :
#         input:
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_copied.fasta"
#         output:
#                 "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_BUSCO"
#         shell: 
#                 "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 --cpu=8"





################################################################# Rules abandonnées ############################################################## 



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
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}DNAZoo.fasta"
#	shell:
#		"cp {input} {output}"

#rule copy_NCBI :
#        input:
#                "/media/newvol/yascimkamel/Pipeline/genome/{espece}/{espece}_{BD}NCBI.fna"
#        output:
#                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}NCBI.fna"
#        shell:
#                "cp {input} {output}"

#rule uncompress :
#	input: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}.gz"
#	output: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblage}"
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
  #              "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/read/{espece}_{BD}DNAZoo_read.txt"
   #     shell:
    #            "wc -l {input} > {output}"




    #rule merge_read:
#	    input :
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/read/{espece}_{BD}DNAZoo_read.txt",
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{espece}_{BD}NCBI_read.txt"
#	    output :
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{espece}_{BD}all_read.txt"
#	    shell:
#	            "cat{input} >> {output}"
#	            "rm {input}"

