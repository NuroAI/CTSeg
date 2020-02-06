#!/usr/bin/env bash


subj=$1
DESTDIR=$2

echo "Started at: $(date)"
flirt -in $subj -ref $CTSEGPATH/utils/rscct.nii -out $DESTDIR/reg -omat $DESTDIR/tmat.txt
echo "Finished at: $(date)"