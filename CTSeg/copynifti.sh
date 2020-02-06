#!/usr/bin/env bash

export SUBJDIR=$1
export DESTDIR=$2
export SUBJLIST=$3

while read s
do
echo "${s}/reg.nii"
c3d $SUBJDIR/$s/reg.nii.gz $DESTDIR/$s/reg.nii
done < $SUBJLIST
