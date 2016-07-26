
% Matlab to TDT communication example:

% Open connection with TDT and begin program
DA = actxcontrol('TDevAcc.X');
DA.ConnectServer('Local'); %initiates a connection with an OpenWorkbench server. The connection adds a client to the server

if DA.CheckServerConnection ~= 1 %checks that the server is connected to OpenWorkbench
    error('Client application (i.e. OpenWorkbench) is not connected to server');
end

% Disarm the stim
DA.SetTargetVal('RZ5D.ArmSystem', 0);
DA.SetTargetVal('RZ5D.IsArmed', 0);
if DA.GetSysMode ~= 3 %if OpenWorkbench is not in Record mode, then this will set it to record
    DA.SetSysMode(3);
    while DA.GetSysMode ~= 3
        pause(.1)
    end
    % Disarm the stim - MAY NOT NEED TO DO THIS!
    DA.SetTargetVal('RZ5D.ArmSystem', 0);
end

% Initizlize values
tank = DA.GetTankName;

if DA.GetTargetVal('RZ5D.IsArmed') == 0
    disp('System is not armed');
elseif DA.GetTargetVal('RZ5D.IsArmed') == 1
    disp('System armed');
end

DA.SetTargetVal('RZ5D.TotalMatlabTrials', params(length(params), 1));

index = 0;
while DA.GetTargetVal('RZ5D.End') ~= 1
    if DA.GetTargetVal('RZ5D.Next') == 1
        % DO STUFF
        DA.SetTargetVal('RZ5D.Next', 0);
        
    elseif DA.GetTargetVal('RZ5D.Previous') == 1
        % DO STUFF
        DA.SetTargetVal('RZ5D.Previous', 0);
    elseif DA.GetTargetVal('RZ5D.Restart') == 1
        % DO STUFF
        DA.SetTargetVal('RZ5D.Restart', 0);
    end
end


% When run is ended, i.e. 'RZ5D.End' == 1

% Save stuff: Currently all saved in TDT - make sure this is ok
file = getLatestFile(tank);
filenum = file((strfind(file, '-')+1):end); % Convert the characters after the hyphen to a double
fileName = strcat(path_to_dataFolder, 'SensoryScreen_', task, subject_ID, '_', datestr(now,30), '-', filenum);
save(fileName, 'params');

% Disarm stim:
DA.SetTargetVal('RZ5D.ArmSystem', 0);

% Close ActiveX connection:
DA.CloseConnection
if DA.CheckServerConnection == 0
    display('Server was disconnected');
end