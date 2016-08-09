

%set up field names for data structure
f0 = 'word';
f1 = 'cnc';
f2 = 'fam';
f3 = 'img';
f4 = 'kffrq';
f5 = 'tlfrq';

%make empty cells to manually copy+paste excel data
twords = cell(0);
awords = cell(0);
pwords = cell(0);

cnc_v = cell(0);
fam_v = cell(0);
img_v = cell(0);
kffrq_v = cell(0);
tlfrq_v = cell(0);

words.tools = struct(f0,twords,f1,cnc_v,f2,fam_v,f3,img_v,f4,kffrq_v,f5,tlfrq_v);
words.animals = struct(f0,awords,f1,cnc_v,f2,fam_v,f3,img_v,f4,kffrq_v,f5,tlfrq_v);
words.places = struct(f0,pwords,f1,cnc_v,f2,fam_v,f3,img_v,f4,kffrq_v,f5,tlfrq_v);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%shit above is kinda wrong
%want to make the words the field names

%something close to this:

words.tools = struct([]);

for i = 1:length of the thing
    
    words.tools.(twords(i)) = the ith row of the (length X 5) matrix containing values
    
end