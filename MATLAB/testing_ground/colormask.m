
%script for prime masking idea, where letters appear/disappear in colors

sca
clear

numtrials = 5;

wordlist = {'CAT','DOG','BARN','RAKE','HOUSE','DRILL','HAMMER','ANCHOR'};

rand_cloc = input('Randomize placement of colors? y/n [y]: ','s');
easy = input('Easy mode? y/n [y]: ','s');

%Setup PTB with some default values
PsychDefaultSetup(2);

%set screen num to secondary monitor if one is connected
screenNumber = max(Screen('Screens'));
% screenNumber = 1;  %weirdness with how tms task computer assigns window numbers

%define colors
%to reference colors from cvars/bwgvars: colors.(cvars{n})
bwgvars = {'black,','white','grey'};
cvars = {'red','orange','yellow','green','blue','indigo','violet'};

colors.white = WhiteIndex(screenNumber);
colors.grey = colors.white/2;
colors.black = BlackIndex(screenNumber);

colors.red = [1 0 0];
colors.orange = [1 0.35 0];
colors.yellow = [1 1 0];
colors.green = [0 1 0];
colors.blue = [0 0 1];
colors.indigo = [0.25 0 1];
colors.violet = [0.75 0 1];

blue = [0 0 1];

%slightly altered to print priming letters

if easy=='n'
    colors(2).red = [0.97 0 0];
    colors(2).orange = [0.97 0.35 0];
    colors(2).yellow = [0.97 1 0];
    colors(2).green = [0 0.97 0];
    colors(2).blue = [0 0 0.97];
    colors(2).indigo = [0.25 0 0.97];
    colors(2).violet = [0.75 0 0.97];
    ptime = 0.1;
else
    colors(2).red = [0.5 0 0];
    colors(2).orange = [0.5 0.35 0];
    colors(2).yellow = [0.5 1 0];
    colors(2).green = [0 0.5 0];
    colors(2).blue = [0 0 0.5];
    colors(2).indigo = [0.25 0 0.5];
    colors(2).violet = [0.75 0 0.5];
    ptime = 3;
end

%randomize color placement if necessary
if isempty(rand_cloc) || rand_cloc=='y'
    
    color_mat = cat(2,colors(1).red',colors(1).orange',colors(1).yellow',...
        colors(1).green',colors(1).blue',colors(1).indigo',colors(1).violet');
        
    color_mats = cell(numtrials,1);
    
    for i = 1:numtrials
        
        cm_idx(i,:) = randperm(size(color_mat,2));
        
        color_mats{i} = color_mat(:,cm_idx(i,:));
        
    end
     
elseif rand_cloc=='n'
    
    color_mat = cat(2,colors(1).red',colors(1).orange',colors(1).yellow',...
        colors(1).green',colors(1).blue',colors(1).indigo',colors(1).violet');
    
    cm_idx = repmat([1 2 3 4 5 6 7],numtrials,1);
    color_mats = cell(numtrials,1);
    color_mats(:) = {color_mat};
    
else
    error('y or n')
end

%PTB doesn't like me referencing colors from structure in certain cases
black = 0;
white = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black, [], 32, 2);

%Flip to clear
Screen('Flip', window);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

%Query frame duration
ifi = Screen('GetFlipInterval', window);

%Set text size and font
Screen('TextSize', window, 60);
Screen('TextFont', window, 'Ariel');

%Query max priority level
topPriorityLevel = MaxPriority(window);

%Get center coordinates of window
[xcenter, ycenter] = RectCenter(windowRect);

%Set blend function for the screen
Screen('BlendFunction',window,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');

HideCursor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%take word from wordlist, find length, get random consecutive index from
%placeholder of same length, dump word into the placeholder

chosen = datasample(wordlist,numtrials,'Replace',false);

for i = 1:numtrials
    
    placeholder = '       ';
    
    clen = length(chosen{i});
    
    if clen==7
        first=1;
        last=7;
    else
        first = randi((-1*clen+8));
        last = first+clen-1; 
    end
    
    placeholder(first:last) = chosen{i};
    
    stim_words{i,1} = placeholder;
    
end

%decide whether to print primed word on left or right, then choose a word
%to pair it against

for i = 1:numtrials
    
    check = rand;
    
    if check <= 0.5
        
        printleft{i,1} = stim_words{i,1};
        choices = datasample(stim_words,2,'Replace',false);
        if ~strcmp(choices(1),stim_words{i,1})
            printright{i,1} = choices{1};
        else
            printright{i,1} = choices{2};
        end
    else
        printright{i,1} = stim_words{i,1};
        choices = datasample(stim_words,2,'Replace',false);
        if ~strcmp(choices(1),stim_words{i,1})
            printleft{i,1} = choices{1};
        else
            printleft{i,1} = choices{2};
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%define the destination rectangles for the colored rectangles
dstRect = [0 0 screenXpixels/8 screenXpixels/8];
dstRect1 = CenterRectOnPointd(dstRect, xCenter*0.25, yCenter);
dstRect2 = CenterRectOnPointd(dstRect, xCenter*0.5, yCenter);
dstRect3 = CenterRectOnPointd(dstRect, xCenter*0.75, yCenter);
dstRectcent = CenterRectOnPointd(dstRect, xCenter, yCenter);
dstRect4 = CenterRectOnPointd(dstRect, xCenter*1.25, yCenter);
dstRect5 = CenterRectOnPointd(dstRect, xCenter*1.5, yCenter);
dstRect6 = CenterRectOnPointd(dstRect, xCenter*1.75, yCenter);

rect_mat = cat(2,dstRect1',dstRect2',dstRect3',dstRectcent',dstRect4',dstRect5',dstRect6');

%define the destination rectangles for the letters
A = Screen('TextBounds',window,'A');
OR = Screen('TextBounds',window,'OR');

loc1 = CenterRectOnPointd(A,xCenter*0.25, yCenter);
loc2 = CenterRectOnPointd(A,xCenter*0.5, yCenter);
loc3 = CenterRectOnPointd(A,xCenter*0.75, yCenter);
loc4 = CenterRectOnPointd(A,xCenter, yCenter);
loc5 = CenterRectOnPointd(A,xCenter*1.25, yCenter);
loc6 = CenterRectOnPointd(A,xCenter*1.5, yCenter);
loc7 = CenterRectOnPointd(A,xCenter*1.75, yCenter);
or_loc = CenterRectOnPointd(OR,xCenter, yCenter);

for i = 1:numtrials
    
    LEFT = Screen('TextBounds',window,printleft{i,1});
    RIGHT = Screen('TextBounds',window,printright{i,1});
    
    left_loc{i,1} = CenterRectOnPointd(LEFT,xCenter*0.5, yCenter);
    right_loc{i,1} = CenterRectOnPointd(RIGHT,xCenter*1.5, yCenter);
    
end

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)

%fixation cross coordinates
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
fixCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

escapeKey = KbName('ESCAPE');
aKey = KbName('LeftArrow');  %"aKey" is actually left arrow
sKey = KbName( 'RightArrow');  %"sKey" is actually right arrow
spacebar = KbName('space');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%want to try to use Screen('FillRect') command once to print all rectangles
%while still maintaining ability to randomize colors referenced from
%structure colors

for trial = 1:numtrials
    
    respToBeMade = true;
    
    %Flip again to sync to vertical retrace at same time as drawing
    %fixation cross
    Screen('DrawLines', window, fixCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
    Screen('Flip', window);
    pause(1)
    
    Screen('FillRect',window,color_mats{trial},rect_mat);
    Screen('Flip',window);
    pause(0.45)
    
    Screen('FillRect',window,color_mats{trial},rect_mat);
    Screen('DrawText',window,stim_words{trial,1}(1),loc1(1),loc1(2),colors(2).(cvars{cm_idx(trial,1)}));
    Screen('DrawText',window,stim_words{trial,1}(2),loc2(1),loc2(2),colors(2).(cvars{cm_idx(trial,2)}));
    Screen('DrawText',window,stim_words{trial,1}(3),loc3(1),loc3(2),colors(2).(cvars{cm_idx(trial,3)}));
    Screen('DrawText',window,stim_words{trial,1}(4),loc4(1),loc4(2),colors(2).(cvars{cm_idx(trial,4)}));
    Screen('DrawText',window,stim_words{trial,1}(5),loc5(1),loc5(2),colors(2).(cvars{cm_idx(trial,5)}));
    Screen('DrawText',window,stim_words{trial,1}(6),loc6(1),loc6(2),colors(2).(cvars{cm_idx(trial,6)}));
    Screen('DrawText',window,stim_words{trial,1}(7),loc7(1),loc7(2),colors(2).(cvars{cm_idx(trial,7)}));
    Screen('Flip',window);
    pause(ptime)
    
    Screen('FillRect',window,color_mats{trial},rect_mat);
    Screen('Flip',window);
    pause(0.45)
    
    Screen('FillRect',window,black);
    Screen('DrawText',window, printleft{trial,1},...
        left_loc{trial,1}(1), left_loc{trial,1}(2), white);
    Screen('DrawText',window, 'OR',...
        or_loc(1), or_loc(2), white);
    Screen('DrawText',window, printright{trial,1},...
        right_loc{trial,1}(1), right_loc{trial,1}(2), white);
    Screen('Flip',window);
    
    
    while respToBeMade == true
        
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(aKey)
            respToBeMade = false;
            respkey{trial,1} = 'left';
            respword{trial,1} = printleft{trial,1};
        elseif keyCode(sKey)
            respToBeMade = false;
            respkey{trial,1} = 'right';
            respword{trial,1} = printright{trial,1};
        end 
    end

end

ShowCursor;
sca;

success = sum(strcmp(stim_words,respword))/length(respword);
disp(success)

