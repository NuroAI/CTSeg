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

echo "Transforming images into cormac units...."
python $CTSEGPATH/CTSeg/imgTransformChris.py $SUBJECTSLIST $OUTPUTDIR $DATADIR .nii


# Registering into MNI Space.
echo "Registering to MNI space"
bash $CTSEGPATH/CTSeg/run_FSL_flirtCT.sh $OUTPUTDIR $OUTPUTDIR $SUBJECTSLIST


# make a .nii copy of the registered image
bash $CTSEGPATH/CTSeg/copynifti.sh $OUTPUTDIR $OUTPUTDIR $SUBJECTSLIST

# Segment the registered image using SPM.
export CTSEGRUNPATH=$OUTPUTDIR
matlab -nodisplay -nosplash -nodesktop -r "run('$CTSEGPATH/CTSeg/SPM_SCRIPT_segment_parallel.m');quit;"

# Create TIV masks
echo "Making tiv masks..."
python $CTSEGPATH/CTSeg/makeTIVmasks.py $OUTPUTDIR $SUBJECTSLIST


# Create TBV masks
echo "Making tbv masks..."
python $CTSEGPATH/CTSeg/makeTBVmasks.py $OUTPUTDIR $SUBJECTSLIST

# Create inverse transformation matrices
echo "Creating native transformation matrix..."
python $CTSEGPATH/CTSeg/make_tmatinv.py $OUTPUTDIR $SUBJECTSLIST

# Transforming to native space
echo "Transforming TIV mask to native space"
bash $CTSEGPATH/CTSeg/flirt_tonative.sh $DATADIR .nii $OUTPUTDIR $SUBJECTSLIST tivmask_image.nii.gz tivmask_native.nii.gz

echo "Transforming TBV mask to native space"
bash $CTSEGPATH/CTSeg/flirt_tonative.sh $DATADIR .nii $OUTPUTDIR $SUBJECTSLIST tbvmask_image.nii.gz tbvmask_native.nii.gz

echo "Transforming csf mask to native space"
bash $CTSEGPATH/CTSeg/flirt_tonative.sh $DATADIR .nii $OUTPUTDIR $SUBJECTSLIST c3reg.nii csf_native.nii.gz
