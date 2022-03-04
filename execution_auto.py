#!/usr/bin/env python3
import os

### On met en place les listes des espèces et bases de données à tester

liste = ["Globicephala_melas", "Tursiop_truncatus","Megaptera_novaeangliae",]
liste_BD = ["DNAZoo", "NCBI"]


j=0
while j< len(liste_BD):
	print("\n\n Copie des données depuis : \n\n        " + liste_BD[j] +"\n" )
	i=0
	while i < len (liste):

#################################################################### Lignes de commandes test ##############################################################################################################

	#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna "
	#	commande = "snakemake --cores 8 uncompress /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/" + liste[i] + "_DNAZoo.fasta /media/newvol/yascimkamel/Pipeline/Snakemake/copie/"+ liste[i] +"/" + liste[i] +"_NCBI.fna"
	#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_DNAZoo_read.txt"
	#	commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i] +"/read/" + liste[i] + "_all_read.txt"

############################################################################################################################################################################################################
		
#Au sien d'une base de données on lance lune commande snakemake par espèce
		print("\n\n Lancement de la commande pour \n\n        " +  liste[i] + "\n\n")
		commande ="snakemake --cores 8 /media/newvol/yascimkamel/Pipeline/Snakemake/copie/" + liste[i]+"/read/" + liste[i] +"_" + liste_BD[j] + "_ligne.txt"
		i+=1
		#on lance la commande
		os.system(commande) #Lancement de la commande shell
	j+=1

