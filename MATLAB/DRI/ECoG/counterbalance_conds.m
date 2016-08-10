numtrials = 60;
numblocks = 1;

stimchoices = [2,9];

fingers{1} = 'INDEX';
fingers{2} = 'MIDDLE';
evenodd{1} = 'EVEN';
evenodd{2} = 'ODD';
symbols = ['A' 'B'];

chooser = [1 2];

%randomize itis/isis
itis = randi([60 210],numtrials,numblocks);
isis = randi([15 120],numtrials,numblocks);


%randomize trial stuffs
for block = 1:numblocks
    
    %randomize order of condition presentation and record it
    condMatrixtemp = sort(repmat([0 1], 1, numtrials/2));
    condMatrix(:,block) = condMatrixtemp(:,Shuffle(1:numtrials))'; %0==symbols 1==fingers
    
    for trial = 1:numtrials
        
        %determine stimulus and record what it is
        stim(trial,block) = randi(stimchoices);
        printstim_l1(trial,block) = num2str(stim(trial,block));
        
        %decide which symbols/fingers are assigned to even/odd and record
        evenoddchooser{trial,block} = Shuffle(chooser);  %1==Even
        symbolchooser{trial,block} = Shuffle(chooser);  %1==A
        fingerchooser{trial,block} = Shuffle(chooser);  %1==Index
        abchooser{trial,block} = Shuffle(chooser);  %1==A
        
        %make strings to present
        %decide whether to print even or odd
        print_evenodd{trial,block} = [evenodd{evenoddchooser{trial,block}(1)}];

        %determine placement of A and B on screen
        printstim_l2(trial,block) = symbols(abchooser{trial,block}(1)); %prints on left of screen
        printstim_l3(trial,block) = symbols(abchooser{trial,block}(2)); %prints on right of screen

    end
end