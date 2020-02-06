#!/bin/bash

# ls *.gz > subject_list

DATADIR=$1
EXT=$2
FILENAME="CTSeg_subjectlist.txt"

rm -f ./$FILENAME

for s in `ls $DATADIR/*$EXT`
do
echo `basename ${s%%$EXT}`>>$FILENAME
mkdir -p `basename ${s%%$EXT}`;
done

