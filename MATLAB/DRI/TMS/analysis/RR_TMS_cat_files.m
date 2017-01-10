%short script to first concatenate individual subject block files into one
%subject file, then concatenate subject files into one project file


datapath = uigetdir;
cd(datapath)
subj_folders = dir;

%first, concatenate the individual subject block files into one file for
%each subject, then concatenate the subject files into one group file

%dropped subj 2406 due to coil drifting off target in first block; can
%manually add blocks 2,3,4 later if we want to

%cat indiv subj block files
for i = 3:length(subj_folders)%3:length() because first two are . and ..
    
    RR_TMS_filecat(datapath,subj_folders(i).name)
    
end

%cat subj files into group file
fname = RR_TMS_catcat(datapath);

%load the newly created file
load(fname)