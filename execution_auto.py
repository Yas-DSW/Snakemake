#!/usr/bin/env python3
import os

liste = ["Globicephala_melas_DNAZoo", "Tursiop_truncatus_DNAZoo","Megaptera_novaeangliae_DNAZoo","Globicephala_melas_NCBI", "Tursiop_truncatus_NCBI","Megaptera_novaeangliae_NCBI"]

i=0

while i< len(liste):
	#on génére la commande qui sera utilisé pour lancer le snakemake 
#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna "
#	commande = "snakemake --cores 8 uncompress /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna"
#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_DNAZoo_read.txt"
#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_all_read.txt"
	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_ligne.txt"
	i+=1
	print (commande)
	#on lance la commande
	os.system(commande)
