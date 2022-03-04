#!/usr/bin/env python3
import os

liste = ["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae"]

i=0

while i< len(liste):
	#on génére la commande qui sera utilisé pour lancer le snakemake 
#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna "
#	commande = "snakemake --cores 8 uncompress /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna"
#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_DNAZoo_read.txt"
#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_all_read.txt"
	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "__ligne.txt.txt"
	i+=1
	print (commande)
	#on lance la commande
	os.system(commande)
