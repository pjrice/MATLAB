% ControllingStimulatorExample
%
% - Description 
%   This script uses Rapid2 Matlab toolbox to control Magstim Rapid2 stimulator. 
%   The stimulator and computer need need to be connected via a serial connection. 
%   If you happen to be using another COM port, such as COM2 or COM3, change the name of the
%   serial port on line 24
% 
% - Usage 
%   Press 1 to arm the stimulator first
%   Press 'Right Shift' to increase stimulation intensity or 'Left Shift' to decrease
%   Press Spacebar to deliver a pulse
%   Press Esc to disarm the stimulator and quit the program
%
% - Development
%   08.12.2009, Implemented by Arman
%
% - Download page
%   http://www.psych.usyd.edu.au/tmslab/rapid2andrept.html


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

% Set initial power level to 30% of output
powerLevel = 30;
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

% start a loop where key presses are processed
% Pressing Up Arrow key will increase stimulator's power level while
% pressing Down Arrow key will decrease stimulator's power level
% Pressing Spacebar will deliver a pulse.
% Pressing Esc will disarm the stimulator and quit the program
% you will need free Psychtoolbox to be installed for the following code to work

KbName('UnifyKeyNames'); % to increase portability of the code between different platforms

% Get keycodes from the operating system
oneKey = KbName('1'); % to arm the stimulator
zeroKey = KbName('0'); % to disarm the stimulator
upKey = KbName('RightShift'); % to increase the power level
downKey = KbName('LeftShift'); % to decrease the power level
spaceKey = KbName('Space'); % trigger a pulse
escapeKey = KbName('Escape'); % disarm the stimulator and exit

loopUntilEscape = 0;
while ~loopUntilEscape
    [keyIsDown, keySecs,keyCode] = KbCheck;

    if keyIsDown
        if keyCode(oneKey)
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
        end
        if keyCode(zeroKey)
            success = Rapid2_DisarmStimulator(serialPortObj);
            if ~success
                display 'Error: Cannot disarm the stimulator';
                runLoop = 0;
            else
                display 'Stimulator is disarmed';
            end
            Rapid2_Delay(150, serialPortObj);
        end

        if keyCode(upKey)

            % power level cannot be more than 100%
            if powerLevel < 100
                powerLevel = powerLevel + 1;

                success = Rapid2_SetPowerLevel(serialPortObj, powerLevel, 1);
                if ~success
                    display 'Error: Cannot set the power level';
                    return
                else
                    % Display power level;
                    display(powerLevel);
                    % Introduce delay to allow the  stimulator to adjust to the new power level
                    % and to avoid fast changes of the power level
                end
                Rapid2_Delay(150, serialPortObj);
                
            end
        elseif keyCode(downKey)
            % power level cannot be less than 1%
            if powerLevel > 1
                powerLevel = powerLevel - 1;
                success = Rapid2_SetPowerLevel(serialPortObj, powerLevel, 1);
                if ~success
                    display 'Error: Cannot set the power level';
                    return
                else
                    % Display power level;
                    display(powerLevel);
                    % Introduce delay to allow the  stimulator to adjust to the new power level
                    % and to avoid fast changes of the power level
                end
            end
            Rapid2_Delay(150, serialPortObj);
            
        elseif keyCode(spaceKey)
            % trigger the stimulator
            success = Rapid2_TriggerPulse(serialPortObj, 1);
            if ~success
                display 'Error: Cannot trigger a pulse';
                return
            else
                display 'Triggered stimulator';
            end
            Rapid2_Delay(150, serialPortObj);
        elseif keyCode(escapeKey)

            % disarm the stimulator and break out of program when Escape key is pressed
            success = Rapid2_DisarmStimulator(serialPortObj);
            if ~success
                display 'Error: Cannot disarm the stimulator';
                runLoop = 0;
            else
                display 'Stimulator is disarmed';
            end
            loopUntilEscape = 1;

            return;

        end
    end % if keyIsDown

end % while validResponse
