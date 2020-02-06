#!/usr/bin/env bash


export SUBJDIR=$1
export DATAEXT=$2
export DESTDIR=$3
export SUBJLIST=$4
export INPUTIMAGE=$5
export OUTPUTNAME=$6

echo "PROCESSING subjects"
echo "...Registering using inverse transformation matrix"
echo "Started at: $(date)"
while read s
do
echo $s
flirt \
    -in $DESTDIR/$s/$INPUTIMAGE \
    -ref $SUBJDIR/$s$DATAEXT \
    -applyxfm \
    -init $DESTDIR/$s/affine_tonative.txt \
    -out $DESTDIR/$s/$OUTPUTNAME \
    -v
done < $SUBJLIST
echo "Finished at: $(date)"
