clc;
clear all;


%% Initialize variables.
folder = getenv('CTSEGRUNPATH');
filename = fullfile(folder,'CTSeg_subjectlist.txt');
fprintf('Loading subjects file list: \n%s\n',filename);
delimiter = '';


%% Open the text file.
fid=fopen(filename);
file_list = {};
tline = fgetl(fid);
n = 0;
while ischar(tline)
    n = n+1;
    disp(tline)
    file_list{n}=fullfile(folder,tline,'reg.nii');
    tline = fgetl(fid);
end
fclose(fid);


%% SPM PROCESSING

CTSegpath = getenv('CTSEGPATH');


fileToRead1 = fullfile(CTSegpath, 'utils', 'CT_seg.mat');

fprintf('%s\n',fileToRead1)

main_batch = load('-mat',fileToRead1);

numsub = n;

parfor (j = 1:numsub,8)  
    
    defaults = spm_get_defaults;
    spm_jobman('initcfg');
    loop_batch = main_batch;
    
    
    fprintf('Processing subject: %d\n',j);
    c = clock;
    disp(datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
    fprintf('Path: \n%s\n',file_list{j});

    loop_batch.matlabbatch{1, 1}.spm.spatial.preproc.channel.vols{1} = strcat(file_list{j},',1');
    
    
    spmpath = fileparts(which('/spm.m'));
    tpmpath = fullfile(spmpath,'tpm','TPM.nii');
    
    for k = 1:6
        loop_batch.matlabbatch{1, 1}.spm.spatial.preproc.tissue(k).tpm{1} = strcat(tpmpath,',',num2str(k));
    end
    
    matlabbatch = loop_batch.matlabbatch;
    
    %save(fullfile(pwd,subject_id,strcat(subject_id,'-',fileToRead1)),'matlabbatch');
    
    
    output_list = spm_jobman('run',loop_batch.matlabbatch);
    c = clock;
    fprintf('\nFinished processing subject: %d ;\n%s\n',j,datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));  
    
end


