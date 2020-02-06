#!/usr/bin/env bash

export SUBJDIR=$1
export DESTDIR=$2
export SUBJLIST=$3

echo "PROCESSING subjects"
echo "...Registering to CT template"
echo "Started at: $(date)"
while read s
do
echo $s
bash $CTSEGPATH/CTSeg/FSL_flirtCT.sh $SUBJDIR/$s/itrans.nii.gz $DESTDIR/$s
done < $SUBJLIST
echo "Finished at: $(date)"
