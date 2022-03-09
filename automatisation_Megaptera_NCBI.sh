#!/bin/bash

augustus --species=human  Megaptera_novaeangliae_HiC.fasta > sortie_augustus/Megaptera_novaeangliae_HiC Megaptera.gff


bedtools getfasta -fo genes_OR.fasta -fi /media/newvol/yascimkamel/essaie_manuel/Megaptera/Megaptera_novaeangliae_HiC.fasta -bed /media/newvol/yascimkamel/essaie_manuel/Megaptera/sortie_augustus/Megaptera_novaeangliae_HiC_human.gff



or.pl --format=csv --sequence=/media/newvol/yascimkamel/essaie_manuel/Megaptera/genome/Megaptera_novaeangliae_HiC.fasta
