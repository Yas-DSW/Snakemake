#rule read_csv : 
#	input: 
#		"données/données.csv"
#	output: 
#		"données.txt"
#	shell: 
#		"python3 recup_lien.py {input} > {output}"

ESPECE=["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae"]
liste_BD = ["DNAZoo", "NCBI"]



rule copy : ### Permet de copier les génomes
	input: 
		expand("/media/newvol/yascimkamel/Pipeline/genome/copie/{espece}/{espece}_{BD}_f.fasta" for (espece),(BD) in (ESPECE),(liste_BD)
	output:
		expand("/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{espece}_{BD}_copied.fasta" for (espece),(BD) in (ESPECE),(liste_BD)
	shell:
		"cp {input} {output}"



rule read: # Permet d'indiquer dans un fichier txt le nombre de ligne pour un assemblage
        input :
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblie}_copied.fasta"
        output :
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/read/{assemblie}_ligne_number.txt"
        shell:
                "wc -l {input} > {output}"


rule busco :
        input:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblie}_copied.fasta"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblie}_BUSCO"
        shell: 
                "busco -m genome -i {input} -o {output} -l cetartiodactyla_odb10 --cpu=8"





################################################################# Rules abandonnées ############################################################## 



#rule name_recuperation :
#	input: "/media/newvol/yascimkamel/genome/{espece}"
#	output: 
#		"assemblie_{espece}.txt"
#	shell:
#		"ls {input} > assemblie_{wildcards.espece}.txt " 


#rule copy_DNA : 
#	input: 
#		"/media/newvol/yascimkamel/Pipeline/genome/{espece}/{assemblie}DNAZoo.fasta",
#	output:
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblie}DNAZoo.fasta"
#	shell:
#		"cp {input} {output}"

#rule copy_NCBI :
#        input:
#                "/media/newvol/yascimkamel/Pipeline/genome/{espece}/{assemblie}NCBI.fna"
#        output:
#                "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblie}NCBI.fna"
#        shell:
#                "cp {input} {output}"

#rule uncompress :
#	input: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblie}.gz"
#	output: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/{assemblage}"
#	shell: 
#		"unzip {input}"


#rule read_NCBI: 
#	input : 
#		"/media/newvol/yascimkamel/Pipeline/genome/{espece}/{assemblie}NCBI.fasta"
#	output :
#		"/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{assemblie}NCBI_read.txt" 
#	shell: 
#		"wc -l {input} > {output}"


#rule read_DNA:
 #       input :
  #              "/media/newvol/yascimkamel/Pipeline/genome/{espece}/{assemblie}DNAZoo.fasta"
  #      output :
  #              "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/read/{assemblie}DNAZoo_read.txt"
   #     shell:
    #            "wc -l {input} > {output}"




    #rule merge_read:
#	    input :
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/copie/{espece}/read/{assemblie}DNAZoo_read.txt",
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{assemblie}NCBI_read.txt"
#	    output :
#	            "/media/newvol/yascimkamel/Pipeline/Snakemake/{espece}/read/{assemblie}all_read.txt"
#	    shell:
#	            "cat{input} >> {output}"
#	            "rm {input}"

