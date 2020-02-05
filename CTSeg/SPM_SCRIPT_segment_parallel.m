clc;
clear all;


%% Initialize variables.
folder = 'E:\PROCESSED_DATA\HEADCT\Axial-89-verified\spm_2\output';
filename = fullfile(folder,'spm_file_list');
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
    file_list{n}=fullfile(folder,tline);
    tline = fgetl(fid);
end
fclose(fid);


%% SPM PROCESSING

fileToRead1 ='CT_seg.mat';

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
    
    matlabbatch = loop_batch.matlabbatch;
    
    %save(fullfile(pwd,subject_id,strcat(subject_id,'-',fileToRead1)),'matlabbatch');
    
    
    output_list = spm_jobman('run',loop_batch.matlabbatch);
    c = clock;
    fprintf('\nFinished processing subject: %d ;\n%s\n',j,datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));  
    
end


