#!/usr/bin/env bash


Augustus --specie=human  --start =off --stop=off --introns=off --protein=off cds =off exonnames=on --coddingseq=on Globicephalas_melas.fa > sortie.gff

getAnnoFasta.pl --seqfile= Globicephalas_melas.fa sortie.gff