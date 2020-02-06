

import nibabel.nifti1 as nitool
import os
import sys

#%% 

data_folder = sys.argv[1]

gm_filename = r'c1reg.nii'
wm_filename = r'c2reg.nii'

sublist_filename = sys.argv[2]
with open(sublist_filename,'rt') as sublistfile:
    lines = sublistfile.readlines()
sublist = [k.rstrip() for k in lines]

#%%

for i in sublist:
    print(i)
    gm_file = nitool.load(os.path.join(data_folder,i,gm_filename))
    gm_img = gm_file.get_data()
    
    wm_file = nitool.load(os.path.join(data_folder,i,wm_filename))
    wm_img = wm_file.get_data()
    
    tbv_img = gm_img + wm_img
    tbv_file = nitool.Nifti1Image(tbv_img,gm_file.affine)
    tbv_filename = os.path.join(data_folder,i,'tbvmask_image.nii.gz')
    print(tbv_filename)
    nitool.save(tbv_file,tbv_filename)
    
    