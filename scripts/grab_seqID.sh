#!/bin/bash

filename=$1
while read line; do # reading each line

grep "^>" $line > $line.seqID

done < $filename
