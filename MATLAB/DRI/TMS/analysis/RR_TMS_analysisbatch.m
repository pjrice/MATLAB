%batch script to process RR_TMS behavioral data
%actually do it for realsies, make it flexible so if we collect more data
%you can run it once and get everything again
%then, use as a base to replicate into python and R

%first, concatenate the individual subject block files into one file for
%each subject, then concatenate the subject files into one group file

%next, preprocessing
%correct timestamps
%get response times
%make indicies of individual trial conditions (sym/fin, es/ls/ns, inst/inf)
%find successful trials and error trials

%make plots along different dimensions of condition space
%condition space 4d (es/ls/ns X PMd/Vertex X sym/fin X inst/inf)
%3d bar plot?
%es/ls/ns X PMd/Vertex X inst/inf; es/ls/ns X PMd/Vertex X sym/fin; 
%sym/fin X instr/inf X PMd/Vertex; etc etc etc... 

%after those made, get differences between conditions to reduce
%dimensionality and make more sensible plots (or just do this first??? but
%it would be helpful to see the plots to make the differences)
