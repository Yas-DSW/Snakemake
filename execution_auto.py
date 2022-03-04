#!/usr/bin/env python3
import os

liste = ["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae",]
liste_BD = ["DNAZoo", "NCBI"]
i=0
j=0


while j< len(liste_BD):
	print(liste_BD[j])
	while i < len (liste):
		#on génére la commande qui sera utilisé pour lancer le snakemake 
	#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna "
	#	commande = "snakemake --cores 8 uncompress /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna"
	#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_DNAZoo_read.txt"
	#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_all_read.txt"
		commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i]+"/read/" + liste[i] +"_" + liste_BD[j] + "_ligne.txt"
		i+=1
		print (commande)
		#on lance la commande
		os.system(commande)
	j+=1

