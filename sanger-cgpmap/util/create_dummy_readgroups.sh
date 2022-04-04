#!/bin/bash
set -euo pipefail
infile=$1

# Use input file with table of form (space sep.)
# ID1 ID1_1.fq.gz ID1_2.fq.gz
# ID2 ID2_1.fq.gz ID2_2.fq.gz

while read p; do

    id=$(echo "${p}" | cut -f1 -d" ")
    fq1=$(echo "${p}" | cut -f2 -d" ")
    fq2=$(echo "${p}" | cut -f3 -d" ")

    outfile="${id}_readgroups.yaml"

    echo "Writing ${outfile}"
    echo "SM: ${id}" > $outfile
    echo "READGRPS:" >> $outfile
    echo "    ${fq1}:"  >> $outfile 
    echo "        ID: ${id}"  >> $outfile 
    echo "        PL: ILLUMINA"  >> $outfile 
    echo "        LB: ${id}"  >> $outfile 
    echo "        PU: ${id}"  >> $outfile 
    echo "    ${fq2}:"  >> $outfile 
    echo "        ID: ${id}"  >> $outfile 
    echo "        PL: ILLUMINA"  >> $outfile 
    echo "        LB: ${id}"  >> $outfile 
    echo "        PU: ${id}"  >> $outfile 

done < $infile
