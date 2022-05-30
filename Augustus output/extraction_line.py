#!/usr/local/bin/python

import sys
import re

gff_file=sys.argv[1]

fg= open(gff_file,"r")
sg= open("only_gene.txt", "w")

for line in fg:
	if "gene" in line:
		sg.write(line)

fg.close()
sg.close()