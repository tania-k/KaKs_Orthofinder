#!/bin/bash

filename=$1
while read line; do # reading each line

sed '/^>/s///' $line > $line.clean.seqID.fa

done < $filename
