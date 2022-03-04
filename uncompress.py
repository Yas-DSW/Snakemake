import os
from os import listdir
from os.path import isdir, isfile, join


## On se place dans le dosserier contenant les copies

os.chdir("copie")

### On récupère tous les nom des dossiers
dossier= listdir()

for d in dossier: 
	fichier=[f for f in listdir(d) if isfile(join(d,f))]
	os.chdir(d)
	print(fichier)
	for f in fichier :
		fichier_decompress= "uncompress " + f 
		os.system(fichier_decompress)
		print(fichier_decompress + "décompresser")
	os.chdir("..")
