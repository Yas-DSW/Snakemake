#!/usr/bin/env bash

fichier_a_analyser=$1
#fichier_de_sortie=$2

total=$(grep -c ">" $1);
echo Nombre total de gene/pseudogene OR : $total

pseudogene=$(grep -c "PSEUDOGENE" $1);
echo Nombre total de pseudogene OR : $pseudogene

gene=$(expr $total - $pseudogene);
echo Nombre total de gene : $gene


OR1=$(grep -c "OR1|" $1);
echo  OR1 : $OR1

OR2=$(grep -c "OR2|" $1);
echo  OR2 : $OR2

OR3=$(grep -c "OR3|" $1);
echo  OR3 : $OR3

OR4=$(grep -c "OR4|" $1);
echo  OR4 : $OR4

OR5=$(grep -c "OR5|" $1);
echo  OR5 : $OR5

OR6=$(grep -c "OR6|" $1);
echo  OR6 : $OR6

OR7=$(grep -c "OR7|" $1);
echo  OR7 : $OR7

OR8=$(grep -c "OR8|" $1);
echo  OR8 : $OR8

OR9=$(grep -c "OR9|" $1);
echo  OR9 : $OR9

OR10=$(grep -c "OR10|" $1);
echo  OR10 : $OR10

OR11=$(grep -c "OR11|" $1);
echo  OR11 : $OR11

OR12=$(grep -c "OR12|" $1);
echo  OR12 : $OR12

OR13=$(grep -c "OR13|" $1);
echo  OR13 : $OR13

OR14=$(grep -c "OR14|" $1);
echo  OR14 : $OR14

OR51=$(grep -c "OR51|" $1);
echo  OR51 : $OR51

OR52=$(grep -c "OR52|" $1);
echo  OR52 : $OR52

OR55=$(grep -c "OR55|" $1);
echo  OR55 : $OR55

OR56=$(grep -c "OR56|" $1);
echo  OR56 : $OR56