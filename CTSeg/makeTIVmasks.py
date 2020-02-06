

import nibabel.nifti1 as nitool
import os
import sys

#%% 

data_folder = sys.argv[1]

gm_filename = r'c1reg.nii'
wm_filename = r'c2reg.nii'
csf_filename = r'c3reg.nii'

sublist_filename = sys.argv[2]

with open(sublist_filename,'rt') as sublistfile:
    lines = sublistfile.readlines()
sublist = [k.rstrip() for k in lines]

#%%

for i in sublist:
    print(i)
    gm_file = nitool.load(os.path.join(data_folder, i, gm_filename))
    gm_img = gm_file.get_data()
    
    wm_file = nitool.load(os.path.join(data_folder, i, wm_filename))
    wm_img = wm_file.get_data()
    
    csf_file = nitool.load(os.path.join(data_folder, i, csf_filename))
    csf_img = csf_file.get_data()
    
    tiv_img = gm_img + wm_img + csf_img
    tiv_file = nitool.Nifti1Image(tiv_img, gm_file.affine)
    tiv_filename = os.path.join(data_folder, i, 'tivmask_image.nii.gz')
    print (tiv_filename)
    nitool.save(tiv_file,tiv_filename)
    
    