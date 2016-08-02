% Initialise COM1 serial port to control the stimulator
% Create serial port object and set its properties to communicate with the
% Magstim stimulator. Change the name of the port if it happens to have a different
% name in your system (e.g., COM2).
serialPortObj = serial('COM1', 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none', 'Terminator', '?');

% Callback function to execute every 500 ms to ensure that the stimulator
% is in the remote control mode and will stay armed. Otherwise,
% stimulator will disarm itself automatically in about 1 sec.
serialPortObj.TimerPeriod = 0.5; % period of executing the callback function in sec
fopen(serialPortObj);
serialPortObj.TimerFcn = {'Rapid2_MaintainCommunication'};

Rapid2_Delay(150, serialPortObj);

powerlevel = input('Power level (% of output)? ');

success = Rapid2_SetPowerLevel(serialPortObj, powerLevel, 1);
if ~success
    display 'Error: Cannot set the power level';
    return
else
    % Display power level;
    display(powerLevel);
    % Introduce delay to allow the  stimulator to adjust to the new power level
    Rapid2_Delay(150, serialPortObj);
end

% Arm the stimulator
success = Rapid2_ArmStimulator(serialPortObj);
if ~success
    display 'Error: Cannot arm the stimulator';
else
    display 'Stimulator is armed';
    Rapid2_Delay(150, serialPortObj);
    % Disable coil safety switch to avoid manully pressing it down to deliver a
    % pulse
    success = Rapid2_IgnoreCoilSafetySwitch(serialPortObj);
    if ~success
        display 'Error: Cannot disable the safety switch on the coil';
    else
        display 'Coil safety switch is deactivated';
    end
    
    Rapid2_Delay(150, serialPortObj);
    
end


% trigger the stimulator
success = Rapid2_TriggerPulse(serialPortObj, 1);
if ~success
    display 'Error: Cannot trigger a pulse';
    return
else
    display 'Triggered stimulator';
end
Rapid2_Delay(150, serialPortObj);


% disarm the stimulator and break out of program when Escape key is pressed
success = Rapid2_DisarmStimulator(serialPortObj);
if ~success
    display 'Error: Cannot disarm the stimulator';
    runLoop = 0;
else
    display 'Stimulator is disarmed';
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    