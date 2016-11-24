%determine correct and incorrect answers



%generate "bitrows" of possible condition combinations

%First column: evenodd (whether even/odd was presented): 0==Even; 1==Odd
%Second column: symbol (whether A/B was presented): 0==A; 1==B
%Third column: ab (whether A was on the left or right): 0==A left; 1==A right
%Fourth column: evenodd_stim (whether the stimulus was even/odd): 0==Even; 1==Odd
symcond_combos = double([permpos(0,4);permpos(1,4);permpos(2,4);permpos(3,4);permpos(4,4)]);

%first column of symcond_clabel is: 
%1. whether Even(E)/Odd(O) presented
%2. whether A(A)/B(B) presented
%3. whether A was on left(L) or right(R) side
%4. whether stimulus was Even(E)/Odd(O)
%Ex: EBRO is Even::B presented; A was on the right; stimulus was odd
symcond_clabel{1,1} = 'EALE';
symcond_clabel{2,1} = 'OALE';
symcond_clabel{3,1} = 'EBLE';
symcond_clabel{4,1} = 'EARE';
symcond_clabel{5,1} = 'EALO';
symcond_clabel{6,1} = 'OBLE';
symcond_clabel{7,1} = 'OARE';
symcond_clabel{8,1} = 'OALO';
symcond_clabel{9,1} = 'EBRE';
symcond_clabel{10,1} = 'EBLO';
symcond_clabel{11,1} = 'EARO';
symcond_clabel{12,1} = 'OBRE';
symcond_clabel{13,1} = 'OBLO';
symcond_clabel{14,1} = 'OARO';
symcond_clabel{15,1} = 'EBRO';
symcond_clabel{16,1} = 'OBRO';

%second column is what the correct answer is (Index(L)/Middle(R))
symcond_clabel{1,2} = 'L';
symcond_clabel{2,2} = 'R';
symcond_clabel{3,2} = 'R';
symcond_clabel{4,2} = 'R';
symcond_clabel{5,2} = 'R';
symcond_clabel{6,2} = 'L';
symcond_clabel{7,2} = 'L';
symcond_clabel{8,2} = 'L';
symcond_clabel{9,2} = 'L';
symcond_clabel{10,2} = 'L';
symcond_clabel{11,2} = 'L';
symcond_clabel{12,2} = 'R';
symcond_clabel{13,2} = 'R';
symcond_clabel{14,2} = 'R';
symcond_clabel{15,2} = 'R';
symcond_clabel{16,2} = 'L';


%First column: evenodd (whether even/odd was presented): 0==Even; 1==Odd
%Second colum: finger (whether index/middle was presented): 0==Index; 1==Middle
%Third column: evenodd_stim (whether the stimulus was even/odd): 0==Even; 1==Odd
fincond_combos = double([permpos(0,3);permpos(1,3);permpos(2,3);permpos(3,3)]);

%first column of fincond_clabel is: 
%1. whether Even(E)/Odd(O) presented
%2. whether Index(I)/Middle(M) presented
%3. whether stimulus was Even(E)/Odd(O)
%Ex: OME is Odd::Middle presented; stimulus was even
fincond_clabel{1,1} = 'EIE'; 
fincond_clabel{2,1} = 'OIE'; 
fincond_clabel{3,1} = 'EME'; 
fincond_clabel{4,1} = 'EIO'; 
fincond_clabel{5,1} = 'OME'; 
fincond_clabel{6,1} = 'OIO'; 
fincond_clabel{7,1} = 'EMO'; 
fincond_clabel{8,1} = 'OMO'; 

%second column is what the correct answer is (Index(L)/Middle(R))
fincond_clabel{1,2} = 'L';
fincond_clabel{2,2} = 'R';
fincond_clabel{3,2} = 'R';
fincond_clabel{4,2} = 'R';
fincond_clabel{5,2} = 'L';
fincond_clabel{6,2} = 'L';
fincond_clabel{7,2} = 'L';
fincond_clabel{8,2} = 'R';


%now, we have possible condition combos for both the finger and symbol
%condition.
%make loop to check a given trials' combo row against one of the two matrices,
%depending on whether the trial was finger or symbol

%first: consolidate all the nested for loops that go by subject then
%by block, so you can make the test rows out of the resultant matrices











