if isempty(which('udp'))
    error('No udp function found. Make sure you have Instrument Control Toolbox installed')
end

close all; clear all; clc
    
bRead = 0
bWrite = 1

% enter RZ's IP address or NetBIOS name here:
TDT_UDP_HOSTNAME = 'TDT_UDP_22_1012';

% every RZ UDP command starts with this
MAGIC = '55AA';

% UDP command constants
CMD_SEND_DATA        = '00';
CMD_GET_VERSION      = '01';
CMD_SET_REMOTE_IP    = '02';
CMD_FORGET_REMOTE_IP = '03';

% Important: the RZ UDP interface port is fixed at 22022
UDP_PORT = 22022;

% create a UDP socket object, connect the PC to the target UDP interface
try
    u = udp(TDT_UDP_HOSTNAME, UDP_PORT, 'InputBufferSize', 1024);
catch
    error('problem creating UDP socket')
end

% bind preliminary IP address and port number to the PC
fopen(u);
get(u, 'Status')

% configure the header. Notice that it includes the header
% information followed by the command 2 (set remote IP)
% and hex '00' (no data packets for header).

% Sends the packet to the UDP interface, setting the remote IP
% address of the UDP interface to the host PC
disp('writing header')
fwrite(u, hex2dec([MAGIC, CMD_SET_REMOTE_IP, '00']), 'int32');

if bRead
    disp('reading data')
    i = 1;
    while 1
        disp(['iteration ' num2str(i)])
    
        % read a single packet in as floats
        A = fread(u, 1, 'single');

        if ~isempty(A)
            
            % check that magic number is in first position of packet
            head = typecast(single(A(1)), 'uint32');
            if bitshift(head, -16) == hex2dec(MAGIC)
                num_chan = bitand(head, 2^16-1);
           
                disp(['number of channels ' num2str(num_chan)])
                data = A(2:end)
				
                %data = typecast(int32(A(2:end)), 'single') %convert to single
                %process data
            end
        else
            break
        end
    
        i = i + 1;
    end
end

if bWrite
    disp('sending data')
    NPACKETS = 16;

    disp('writing header')
    header = hex2dec([MAGIC, CMD_SEND_DATA, dec2hex(NPACKETS)])

    count = 0
    while 1
        fakeval = mod(count, 10);
        data = fakeval:NPACKETS+fakeval;
        data = int32(data)
    
        disp(['sending packet ' num2str(count)]);
        fwrite(u, [header, data], 'int32');
    
        pause(0.2)
        count = count + 1;
    end
end

disp('cleaning up')
fclose(u);
delete(u);
clear u
