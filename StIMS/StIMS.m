%script to collect hand/arm EMG during tACS stimulation of motor cortex

%channel 1 of EMG will ALWAYS be on left arm, CH2 ALWAYS on right arm

tacs_freq = input('What is the frequency of tACS stimulation for this trial (Hz)? ');

filename = 'C:\data\StIMS\data\';
filename_append = input('Filename? ','s');
filename = strcat(filename,filename_append);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%setup LabJack U3
ljasm = NET.addAssembly('LJUDDotNet'); %Make the UD .NET assembly visible in MATLAB
ljudObj = LabJack.LabJackUD.LJUD;

i = 0;
k = 0;
ioType = 0;
channel = 0;
dblValue = 0;
dblCommBacklog = 0;
dblUDBacklog = 0;
scanRate = 3000;
delay = 120; %in seconds - this is the maximum possible trial length
numScans = 2*scanRate*delay;  %2x the expected # of scans
numScansRequested = 0;
% Variables to satisfy certain method signatures
dummyInt = 0;
dummyDouble = 0;
dummyDoubleArray = [0];

%Open the first found LabJack U3.
[ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);

%Start by using the pin_configuration_reset IOType so that all
%pin assignments are in the factory default condition.
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);

%Configure FIO0 and FIO1  as analog, all else as digital.
%pass a value of b0000000000000011
%Note that for the last parameter we are forcing the value to an int32
%to ensure MATLAB converts the parameters correctly and uses the proper
%function overload.
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PUT_ANALOG_ENABLE_PORT, 0, 3, int32(16)); %chan 0 only

%Configure the stream:
%Set the scan rate.
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_SCAN_FREQUENCY, scanRate, 0, 0);

%Give the driver a 300 second (5 min) buffer (scanRate * 2 channels * 300 seconds).
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BUFFER_SIZE, scanRate*2*300, 0, 0);

%Configure reads to retrieve whatever data is available without waiting (wait mode LJ_swNONE).
LJ_swNONE = ljudObj.StringToConstant('LJ_swNONE');
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_WAIT_MODE, LJ_swNONE, 0, 0);

%Define the scan list as AIN0 (defined above with PUT_ANALOG_ENABLE_PORT).
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.CLEAR_STREAM_CHANNELS, 0, 0, 0, 0);
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.ADD_STREAM_CHANNEL, 0, 0, 0, 0);
ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.ADD_STREAM_CHANNEL, 1, 0, 0, 0);

%Execute the list of requests.
ljudObj.GoOne(ljhandle);

%Get all the results just to check for errors.
    [ljerror, ioType, channel, dblValue, dummyInt, dummyDbl] = ljudObj.GetFirstResult(ljhandle, ioType, channel, dblValue, dummyInt, dummyDouble);
    finished = false;
    while finished == false
        try
            [ljerror, ioType, channel, dblValue, dummyInt, dummyDbl] = ljudObj.GetNextResult(ljhandle, ioType, channel, dblValue, dummyInt, dummyDouble);
        catch e
            if(isa(e, 'NET.NetException'))
                eNet = e.ExceptionObject;
                if(isa(eNet, 'LabJack.LabJackUD.LabJackUDException'))
                    if(eNet.LJUDError == LabJack.LabJackUD.LJUDERROR.NO_MORE_DATA_AVAILABLE)
                        finished = true;
                    end
                end
            end
            %Report non NO_MORE_DATA_AVAILABLE error.
            if(finished == false)
                throw(e)
            end
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%begin recording emg and time ramp-up period

ready = input('Press enter to begin...');

if exist('ready')
    
    % Start the EMG data stream.
    [ljerror, dblValue] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.START_STREAM, 0, 0, 0);
    
    disp('Waiting for ramp-up...')
    
    for s = 1:30
        
        pause(1)
        
        disp(num2str(s))
        
    end
    
else
    
    error('How did you manage to do this? You''re not ready!')
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%time "active trial" period while EMG is streaming

disp('Active trial time: ')

for s = 1:60
    
    pause(1)
    
    disp(num2str(s))
    
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%time ramp-down period while EMG is streaming

disp('Waiting for ramp-down...')

for s = 1:30
    
    pause(1)
    
    disp(num2str(s))
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get EMG data from buffer

%Init array to store EMG data
adblData = NET.createArray('System.Double', 2*numScans);  %Max buffer size (#channels*numScansRequested)

%Read the data.  We will request twice the number we expect, to
%make sure we get everything that is available.
%Note that the array we pass must be sized to hold enough SAMPLES, and
%the Value we pass specifies the number of SCANS to read.
numScansRequested = int32(numScans);
%Use eGetPtr when reading arrays in 64-bit applications. Also
%works for 32-bits.
[ljerror, numScansRequested] = ljudObj.eGetPtr(ljhandle, LabJack.LabJackUD.IO.GET_STREAM_DATA, LabJack.LabJackUD.CHANNEL.ALL_CHANNELS, numScansRequested, adblData);

%Retrieve the current backlog.  The UD driver retrieves stream data from
%the U3 in the background, but if the computer is too slow for some reason
%the driver might not be able to read the data as fast as the U3 is
%acquiring it, and thus there will be data left over in the U3 buffer.
[ljerror, dblCommBacklog] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.GET_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BACKLOG_COMM, dblCommBacklog, dummyDoubleArray);
disp(['Comm Backlog = ' num2str(dblCommBacklog)])

[ljerror, dblUDBacklog] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.GET_CONFIG, LabJack.LabJackUD.CHANNEL.STREAM_BACKLOG_UD, dblUDBacklog, dummyDoubleArray);
disp(['UD Backlog = ' num2str(dblUDBacklog) sprintf('\n')])

adblData_mat = adblData.double;

%Stop the EMG data stream.
[ljerror, dblValue] = ljudObj.eGet(ljhandle, LabJack.LabJackUD.IO.STOP_STREAM, 0, 0, 0);

clear adblData e eNet ljasm ljerror ljudObj

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%save dat ish

save(filename)

disp('Remember to restart matlab and reseat usb because Patrick''s lazy!')




      
      
    
    