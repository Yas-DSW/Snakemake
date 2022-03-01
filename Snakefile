#rule read_csv : 
#	input: 
#		"données/données.csv"
#	output: 
#		"données.txt"
#	shell: 
#		"python3 recup_lien.py {input} > {output}"


rule name_recuperation :
	output: 
		"assemblie.txt"
	shell:
		"ls /media/newvol/yascimkamel/genome/{espece} > assemblie.txt " 


rule copy : 
	input: 
		expand("~/genome/{assembly}", assembly = assemblie.txt)
	output:
		"/media/newvol/yascimkamel/Snakemake-master/{assembly}"
	shell:
		"cp {input} {output}"