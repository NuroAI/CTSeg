import os
import numpy as np
import sys


def write_tmat_inv(tmat_filename,inv_filename):
    tmat_file = os.path.join(tmat_filename)
    with open(tmat_file, 'rt') as tmatfile:
        lines = tmatfile.readlines()
    
    affine = np.array([[float(m) for m in k.rstrip().split()] for k in lines])       
    affineinv = np.linalg.inv(affine)
    
    tmatinv_filename = os.path.join(inv_filename)
    with open(tmatinv_filename, 'wt') as writefile:
        affineinv_list = affineinv.tolist()
        for i in affineinv_list:
            for j in i:
                writefile.write(str(j)+'  ')
            writefile.write('\n')
    
    return inv_filename
            
            
if __name__ == '__main__' :
    subj_filename = sys.argv[2]#r'E:\PROCESSED_DATA\HEADCT\Axial-89-verified\subject_list'

    with open(subj_filename,'rt') as subjfile:
        lines = subjfile.readlines()
    subjects = [k.rstrip() for k in lines]
    
    tmat_folder = sys.argv[1]#r'E:\PROCESSED_DATA\HEADCT\Axial-89-verified\CT-flirt_itrans\output'
    tmat_filename = 'tmat.txt'
    
    tmatinv_folder = sys.argv[1] #r'E:\PROCESSED_DATA\HEADCT\Axial-89-verified\spm_2\output'
    tmatinv_filename = 'affine_tonative.txt'
    
    for i,sub in enumerate(subjects):
        print(i+1,sub)
        tmat_file = os.path.join(tmat_folder,sub,tmat_filename)
        tmatinv_file = os.path.join(tmatinv_folder,sub,tmatinv_filename)
        
        print(write_tmat_inv(tmat_file, tmatinv_file))
        

        