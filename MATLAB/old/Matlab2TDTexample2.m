% Open connection with TDT and begin program
DA = actxcontrol('TDevAcc.X');
DA.ConnectServer('Local'); %initiates a connection with an OpenWorkbench server. The connection adds a client to the server
if DA.CheckServerConnection == 1 %checks that the server is connected to OpenWorkbench
    % Disarm the stim
    DA.SetTargetVal('Aper_RZ.ArmSystem', 0);
    DA.SetTargetVal('Aper_RZ.IsArmed', 0);
    if DA.GetSysMode ~= 3 %if OpenWorkbench is not in Record mode, then this will set it to record
        DA.SetSysMode(3);
        while DA.GetSysMode ~= 3
            pause(.1)
        end
        % Disarm the stim
        DA.SetTargetVal('Aper_RZ.ArmSystem', 0);
        DA.SetTargetVal('Aper_RZ.IsArmed', 0);
        
        % Initizlize values
        StartingTask = 0;
        DA.SetTargetVal('Aper_RZ.StartingTask', StartingTask);
        DA.SetTargetVal('Aper_RZ.CatchTrial_thisTrial', CatchTrial_thisTrial);
        DA.SetTargetVal('Aper_RZ.CatchTrial?', 0);
        DA.SetTargetVal('Aper_RZ.Catch2?', 0);
        
        tank = DA.GetTankName;
        
        % DO STUFF
        DA.SetTargetVal('Aper_RZ.Aperture', aperture_position_norm);
        DA.SetTargetVal('Aper_RZ.LowTarget', lowTarget);
        DA.SetTargetVal('Aper_RZ.HighTarget', highTarget);
        DA.SetTargetVal('Aper_RZ.Deviation', deviation);
        
        
        % Check that the system is armed before proceeding
        if DA.GetTargetVal('Aper_RZ.IsArmed') == 0
            disp('You have run in an unarmed mode for greater than the recording time. Please either arm the system or exit this program and start again. If you wish to continue, arm the system from TDT and then press any key.');
            pause()
        elseif DA.GetTargetVal('Aper_RZ.IsArmed') == 1
            disp('System armed');
        end
        
        % DO MORE STUFF
        DA.SetTargetVal('Aper_RZ.Aperture', aperture_position_norm);
        DA.SetTargetVal('Aper_RZ.LowTarget', lowTarget);
        DA.SetTargetVal('Aper_RZ.HighTarget', highTarget);
        DA.SetTargetVal('Aper_RZ.Deviation', deviation);
        DA.SetTargetVal('Aper_RZ.Accuracy', accuracy);
        
        % Disarm the stim
        DA.SetTargetVal('Aper_RZ.ArmSystem', 0);
        DA.SetTargetVal('Aper_RZ.IsArmed', 0);
        while DA.GetTargetVal('Aper_RZ.IsArmed')
            pause(0.1)
        end
        if DA.GetTargetVal('Aper_RZ.IsArmed')==0
            disp('System unarmed')
        end
        
        
        DA.SetTargetVal('Aper_RZ.accuracyAverage', accuracyAverage);
        
        
    end
    % Collect stim parameters from TDT
    stm0 = struct();
    stm0.amp = DA.GetTargetVal('Aper_RZ.PulseAmp0');
    stm0.phaseDur = DA.GetTargetVal('Aper_RZ.PulseDur0(us)');
    stm0.IPI = DA.GetTargetVal('Aper_RZ.InterPulseInterval0(us)');
    stm0.trainDur = DA.GetTargetVal('Aper_RZ.PulseTrainDuration0');
    stm0.ITI = DA.GetTargetVal('Aper_RZ.InterTrainInterval0');
    
    stm1 = struct();
    stm1.amp = DA.GetTargetVal('Aper_RZ.PulseAmp1');
    stm1.phaseDur = DA.GetTargetVal('Aper_RZ.PulseDur1(us)');
    stm1.IPI = DA.GetTargetVal('Aper_RZ.InterPulseInterval1(us)');
    stm1.trainDur = DA.GetTargetVal('Aper_RZ.PulseTrainDuration1');
    stm1.ITI = DA.GetTargetVal('Aper_RZ.InterTrainInterval1');
    
    stmCatch = struct();
    stmCatch.amp = DA.GetTargetVal('Aper_RZ.PulseAmpCatch');
    stmCatch.phaseDur = DA.GetTargetVal('Aper_RZ.PulseDurCatch(us)');
    stmCatch.IPI = DA.GetTargetVal('Aper_RZ.InterPulseIntervalCatch(us)');
    stmCatch.trainDur = DA.GetTargetVal('Aper_RZ.PulseTrainDurationCatch');
    stmCatch.ITI = DA.GetTargetVal('Aper_RZ.InterTrainIntervalCatch');
    
    % Idle the TDT system
    DA.SetSysMode(0);
    
    % Save variables in Matlab
    file = getLatestFile(tank);
    filenum = file((strfind(file, '-')+1):end); % Convert the characters after the hyphen to a double
    fileName = strcat(path_to_dataFolder, 'apertureTask_', subject_ID, '_', datestr(now,30), '_trial', num2str(numTrials), '-', filenum);
    save(fileName, 'targetTrace_norm', 'targetSizeFraction', 'raw_range_aperSpace', 'raw_range_unarmed', 'raw_range_aperTask', 'apertureMovements', 'unarmed_trace', 'aperTask_trace', 'calibration', 'spaceTimeEnd', 'path_to_load', 'length_aperTask', 'timingArray', 'testTaskTimeEnd', 'accuracy', 'accuracyAverage', 'stm0', 'stm1', 'stmCatch')
    disp(strcat('Tank file #: ', filenum));
    
    % Close connection to server
    DA.CloseConnection
    if DA.CheckServerConnection == 0
        display('Server was disconnected');
    end
    
elseif DA.CheckServerConnection == 0
    warning('Client application (i.e. OpenWorkbench) is not connected to server');
end



