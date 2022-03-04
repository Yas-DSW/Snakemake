#rule read_csv : 
#	input: 
#		"données/données.csv"
#	output: 
#		"données.txt"
#	shell: 
#		"python3 recup_lien.py {input} > {output}"


#rule name_recuperation :
#	input: "/media/newvol/yascimkamel/genome/{espece}"
#	output: 
#		"assemblie_{espece}.txt"
#	shell:
#		"ls {input} > assemblie_{wildcards.espece}.txt " 


rule copy_DNA : 
	input: 
		"/media/newvol/yascimkamel/Pipeline/genome/{espece}/{assemblie}DNAZoo.fasta",
	output:
		"/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/{assemblie}DNAZoo.fasta"
	shell:
		"cp {input} {output}"

rule copy_NCBI :
        input:
                "/media/newvol/yascimkamel/Pipeline/genome/{espece}/{assemblie}NCBI.fna"
        output:
                "/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/{assemblie}NCBI.fna"
        shell:
                "cp {input} {output}"

#rule uncompress :
#	input: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/{assemblie}.gz"
#	output: 
#		"/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/{assemblage}"
#	shell: 
#		"unzip {input}"


rule read_NCBI: 
	input : 
		"/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/{assemblie}NCBI.fna"
	output :
		"/media/newvol/yascimkamel/Pipeline/Snakemake-master/read/{espece}/{assemblie}NCBI_read.txt" 
	shell: 
		"wc -l {input} > {output}"


rule read_DNA:
        input :
                "/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/{assemblie}DNAZoo.fasta"
        output :
                "/media/newvol/yascimkamel/Pipeline/Snakemake-master/copie/{espece}/read/{assemblie}DNAZoo_read.txt"
        shell:
                "wc -l {input} > {output}"
