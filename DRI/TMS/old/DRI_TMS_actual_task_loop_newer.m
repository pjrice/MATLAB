
    
    trialstart_time(trial,block) = GetSecs;
    
    %Cue to determine whether a response has been made
    respToBeMade = true;
    
    %record the hand that is being used
    respMat{1,trial,block} = hand;
    
    %Flip again to sync to vertical retrace at same time as drawing
    %fixation cross
    Screen('DrawLines', window, fixCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
    [VBLTimestamp(trial,1,block),StimulusOnsetTime(trial,1,block),...
        FlipTimestamp(trial,1,block),Missed(trial,1,block),...
        Beampos(trial,1,block)] = Screen('Flip', window);
    
    
    % Now we present the hold interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp
    for frame = 1:holdTimeFrames - 1
        
        % Draw the fixation point
        Screen('DrawLines', window, fixCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        %Flip to the screen
        Screen('Flip', window);
    end
    
    %present rule
    
    if rpspns(trial,block)==0
        
        fwrite(magstim,0)  %trigger TMS as soon as rule is presented
        stim_timestamp(trial,block) = GetSecs;
        
    end
    %
    if condMatrix(trial,block) == 0  %0==symbols 1==fingers
        
        DrawFormattedText(window, print_evenodd{trial,block},...
            'center', 'center', white);
        Screen('DrawTexture', window,...
            Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
        [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
            FlipTimestamp(trial,2,block),Missed(trial,2,block),...
            Beampos(trial,2,block)] = Screen('Flip', window);
        
        spTimeFramescheck = 1;
        
        while respToBeMade == true && spTimeFramescheck<spTimeFrames
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Symbol_Textures{symbolchooser{trial,block}(1)}, [], dstRect, 0);
            Screen('Flip', window);
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if spTimeFramescheck>30 && keyCode(spacebar)
                
                respToBeMade = false;
                
            end
            
            spTimeFramescheck = spTimeFramescheck + 1;
            
        end
        
    else  %fingers
        
        DrawFormattedText(window, print_evenodd{trial,block},...
            'center', 'center', white);
        Screen('DrawTexture', window,...
            Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
        [VBLTimestamp(trial,2,block),StimulusOnsetTime(trial,2,block),...
            FlipTimestamp(trial,2,block),Missed(trial,2,block),...
            Beampos(trial,2,block)] = Screen('Flip', window);
        
        spTimeFramescheck = 1;
        
        while respToBeMade == true && spTimeFramescheck<spTimeFrames
            
            DrawFormattedText(window, print_evenodd{trial,block},...
                'center', 'center', white);
            Screen('DrawTexture', window,...
                Finger_Textures{fingerchooser{trial,block}(1)}, [], dstRect, 0);
            Screen('Flip', window);
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if spTimeFramescheck>30 && keyCode(spacebar)
                
                respToBeMade = false;
                
            end
            
            spTimeFramescheck = spTimeFramescheck + 1;
            
        end
        
    end
    
    true_SPTF(trial,block) = spTimeFramescheck;
    
    if true_SPTF(trial,block)==spTimeFrames
        
        Screen('FillRect',window,black);
        DrawFormattedText(window, 'Warning! No response detected! Press any key to continue',...
                'center', 'center', white)
        Screen('Flip', window);
        KbStrokeWait;
        
        continue
    end
    
    %fixate between rule presentation and stimulus presentation (aka
    %interstimulus delay)
    
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
    
    [VBLTimestamp(trial,3,block),StimulusOnsetTime(trial,3,block),...
        FlipTimestamp(trial,3,block),Missed(trial,3,block),...
        Beampos(trial,3,block)] = Screen('Flip', window);
    
    
    for frame = 1:isdTimeFrames - 1
        
        Screen('DrawLines', window, allCoords,...
            lineWidthPix, white, [xCenter yCenter], 2);
        
        Screen('Flip', window);
        
    end
    
    %present stimulus, record key pressed and RT
    
    respToBeMade = true;
   
    if rpspns(trial,block)==1
        
        fwrite(magstim,0)  %trigger TMS as soon as stimulus is presented
        stim_timestamp(trial,block) = GetSecs;
        
    end
    
    DrawFormattedText(window, printstim_l1(trial,block), 'center',...
        'center', white);
    DrawFormattedText(window, printstim_l2(trial,block),...
        screenXpixels*0.25, screenYpixels*0.75, white);
    DrawFormattedText(window, printstim_l3(trial,block),...
        screenXpixels*0.75, screenYpixels*0.75, white);
    
    [VBLTimestamp(trial,4,block),StimulusOnsetTime(trial,4,block),...
        FlipTimestamp(trial,4,block),Missed(trial,4,block),...
        Beampos(trial,4,block)] = Screen('Flip', window);
    
    
    spTimeFramescheck = 1;
    
    while respToBeMade == true && spTimeFramescheck<spTimeFrames-1
        
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            respMat{7,trial} = 'Esc';
            respTime(trial,block) = secs;
            ShowCursor;
            sca;
            return
        elseif keyCode(aKey)
            respMat{7,trial} = 'A';
            respTime(trial,block) = secs;
            respToBeMade = false;
        elseif keyCode(sKey)
            respMat{7,trial} = 'S';
            respTime(trial,block) = secs;
            respToBeMade = false;
        end
        
        DrawFormattedText(window, printstim_l1(trial,block), 'center',...
            'center', white);
        DrawFormattedText(window, printstim_l2(trial,block),...
            screenXpixels*0.25, screenYpixels*0.75, white);
        DrawFormattedText(window, printstim_l3(trial,block),...
            screenXpixels*0.75, screenYpixels*0.75, white);
        Screen('Flip', window);
        
        spTimeFramescheck = spTimeFramescheck + 1;
        
    end
    
    true_RPTF(trial,block) = spTimeFramescheck + 1;
    
    %determine length of ITI based off of trial timing so that
    %total length of trial is 10 seconds
    
    time_passed(trial,block) = holdTimeFrames+true_SPTF(trial,block)+isdTimeFrames+true_RPTF(trial,block);  %in frames

    time_passed_secs(trial,block) = time_passed(trial,block)*(1/60);
    tps_ceil(trial,block) = ceil(time_passed_secs(trial,block));
    time_offset(trial,block) = (tps_ceil(trial,block) - time_passed_secs(trial,block))/(1/60); %this is the number of frames to add to time_passed to make time_passed be a whole number of seconds
    
    %             time_offset(trial,block) = (ceil(time_passed(trial,block)*ifi) - time_passed(trial,block)*ifi)/ifi;
    
%     time_remaining(trial,block) = time_offset(trial,block) + 60;
    
    if trial<30 && rpspns(trial,block)==1 && rpspns(trial+1,block)==0
        
        time_remaining(trial,block) = time_offset(trial,block) + long_itis(trial,block);
        
    else
        
        time_remaining(trial,block) = time_offset(trial,block) + itis(trial,block);
        
    end
       
    Screen('FillRect',window,black);
    [VBLTimestamp(trial,5,block),StimulusOnsetTime(trial,5,block),...
        FlipTimestamp(trial,5,block),Missed(trial,5,block),...
        Beampos(trial,5,block)] = Screen('Flip', window);
    
    for frame = 1:1:time_remaining(trial,block) - 1
        
        Screen('FillRect',window,black);
        Screen('Flip', window);
        
    end
    
    trialstop_time(trial,block) = GetSecs;  %relative to streamstart_time
    realtime(trial,block) = toc;  %relative to tic
    
    if rpspns(trial,block)==2
        
        stim_timestamp(trial,block) = nan;
        
    end
   
    delay = (time_passed(trial,block)+time_remaining(trial,block))*(1/60); %in seconds - this was the length of the trial
    numScans = 2*scanRate*delay;  %2x the expected # of scans
    
    %Init array to store EMG data
    adblData = NET.createArray('System.Double', 2*numScans);  %Max buffer size (#channels*numScansRequested)
    
    %Read the data.  We will request twice the number we expect, to
    %make sure we get everything that is available.
    %Note that the array we pass must be sized to hold enough SAMPLES, and
    %the Value we pass specifies the number of SCANS to read.
    numScansRequested = int32(numScans);
    %Use eGetPtr when reading arrays in 64-bit applications. Also
    %works for 32-bits.
    [ljerror, numScansRequested(trial,block)] = ljudObj.eGetPtr(ljhandle, LabJack.LabJackUD.IO.GET_STREAM_DATA, LabJack.LabJackUD.CHANNEL.ALL_CHANNELS, numScansRequested, adblData);
    
    %Retrieve the current backlog.  The UD driver retrieves stream data from
    %the U3 in the background, but if the computer is too slow for some reason
    %the driver might not be able to read the data as fast as the U3 is
    %acquiring it, and thus there will be data left over in the U3 buffer.
    [ljerror, dblCommBacklog] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.GET_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BACKLOG_COMM, dblCommBacklog, dummyDoubleArray);
    disp(['Comm Backlog = ' num2str(dblCommBacklog)])
    
    [ljerror, dblUDBacklog] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.GET_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BACKLOG_UD, dblUDBacklog, dummyDoubleArray);
    disp(['UD Backlog = ' num2str(dblUDBacklog) sprintf('\n')])
    
    adblData_mat{trial,block} = adblData.double;
    
    clear adblData
    
   