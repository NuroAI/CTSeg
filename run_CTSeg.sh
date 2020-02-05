#!/usr/bin/env bash



DATADIR="/media/viraj/DataDrive/PROCESSED_DATA/Grand-headCT/AXIAL_89/CTSeg/data"  #$1
OUTPUTDIR="/media/viraj/DataDrive/PROCESSED_DATA/Grand-headCT/AXIAL_89/CTSeg/output"  # $2


export CTSEGPATH=`pwd`
PYTHONPATH=$CTSEGPATH:$PYTHONPATH


mkdir -p $OUTPUTDIR;
cd $OUTPUTDIR

# create a subject list
bash $CTSEGPATH/CTSeg/create_subjectlist.sh $DATADIR ".nii"

SUBJECTSLIST=$OUTPUTDIR/CTSeg_subjectlist.txt

# Transform intensities to cormac units.

#echo "Transforming images into cormac units...."
#python $CTSEGPATH/CTSeg/imgTransformChris.py $SUBJECTSLIST $OUTPUTDIR $DATADIR .nii


# Registering into MNI Space.

#bash $CTSEGPATH/CTSeg/run_FSL_flirtCT.sh $OUTPUTDIR $OUTPUTDIR $SUBJECTSLIST


# make a .nii copy of the registered image
#bash $CTSEGPATH/CTSeg/copynifti.sh $OUTPUTDIR $OUTPUTDIR $SUBJECTSLIST

# Segment the registered image using SPM.
matlab -nodisplay -nosplash -nodesktop -r "run($CTSEGPATH/CTSeg/SPM_SCRIPT_segment_parallel.m