# -*- coding: utf-8 -*-

from nibabel import nifti1 as nitool
import numpy as np
import os
import sys


def img_transform(img_file_name,save_dir):

    img_hdr = nitool.load(img_file_name)
    img_data = img_hdr.get_data()
    img_shape = img_data.shape
    
    t = img_data.flatten()
    t1 = np.zeros(t.size)
    t1[np.where(t>100)] = t[np.where(t > 100)]+3000
    t1[np.where(np.logical_and(t >= -1000, t <= -100))]=t[np.where(np.logical_and(t >= -1000,t <= -100))]+1000
    t1[np.where(np.logical_and(t >= -99, t <= 100))]=(t[np.where(np.logical_and(t >= -99, t <= 100))]+99)*11+911
    trans_img = t1.reshape(img_shape)
    
    trans_pair = nitool.Nifti1Pair(trans_img,img_hdr.affine)
    save_name = os.path.join(save_dir, 'itrans'+'.nii.gz')
    nitool.save(trans_pair, save_name)
    
    return save_name

    
if __name__ == "__main__":

    sub_list = sys.argv[1]

    save_dir = sys.argv[2]

    data_dir = sys.argv[3]

    ext = sys.argv[4]

    with open(sub_list) as sub_file:
        lines = sub_file.readlines()
    lines = [k.rstrip() for k in lines]
    count = 0

    for sub_name in lines:
        print(img_transform(os.path.join(data_dir, sub_name + ext), os.path.join(save_dir, sub_name)))