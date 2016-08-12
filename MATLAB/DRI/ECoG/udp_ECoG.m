%idea for RPvdsEx circuit: for RZ_UDP_Rec, if NewPack isn't held at zero
% but is instead "nothing" (RZUDP documentation states that "NewPack
% outputs logic high (1) for one sample, denoting that a packet header has
% been found"), then I think I could feed NewPack to a waveform/signal
% generator that itself holds zero until NewPack outputs logic high

%Adapted from TDT_UDP, an example script included with RZ5D documentation

% change fwrite to operate asynchronously?

% enter RZ's IP address or NetBIOS name here:
RZ5D_IP = '10.1.0.100';

% Important: the RZ UDP interface port is fixed at 22022
RZ_UDP_PORT = 22022;

%UDP packet header format:
%  |0x55|0xAA|Cmd|Num|
%4 bytes total
%Num==# of 4 byte data packets expected following header

% every RZ UDP command starts with this
pre_header = '55AA';

% UDP command constants (Cmd)
CMD_SEND_DATA        = '00';
CMD_GET_VERSION      = '01';
CMD_SET_REMOTE_IP    = '02';
CMD_FORGET_REMOTE_IP = '03';

%the number of 4 byte packets we expect to send (equal to the number of
%channels we're sending?)
numpackets = 1;

% configure the header to set the target for receiving packets from the
% RZ. Notice that it includes the header information followed by the 
% command 2 (set remote IP) and hex '00' (no data packets for header).
set_rIP = hex2dec([pre_header, CMD_SET_REMOTE_IP, '00']);

%configure the header to send data to the RZ
sd_header = hex2dec([pre_header,CMD_SEND_DATA, dec2hex(numpackets)]);

%InputBufferSize in bytes
try
    u = udp(RZ5D_IP, RZ_UDP_PORT, 'InputBufferSize', 1024);
catch
    error('problem creating UDP socket')
end

% bind preliminary IP address and port number to the PC
fopen(u);
get(u, 'Status')

% Sends the set_rIP packet to the UDP interface, setting the remote IP
% address of the UDP interface to the host PC
disp('writing header')
fwrite(u, set_rIP, 'int32');

%the data we want to send
data = randi([1 9],1);
data = int32(data);

%sends data packet to RZ box
fwrite(u, [sd_header, data], 'int32');

%clean up
fclose(u);
delete(u);
clear u

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reading and writing examples from TDT_UDP; I think they fucked up in the
%write part (didn't go over read part bc it isn't applicable right now)?
%they set NPACKETS to 16 (16 4-byte packets (or channels?)==64 bytes), but 
%then their screwy always-true while loop generates 17 values to send on
%each loop (length(data)==17; "whos data" returns 68 bytes)
%I really don't think it will work but I cannot test currently

% if bRead
%     disp('reading data')
%     i = 1;
%     while 1
%         disp(['iteration ' num2str(i)])
%     
%         % read a single packet in as floats
%         A = fread(u, 1, 'single');
% 
%         if ~isempty(A)
%             
%             % check that magic number is in first position of packet
%             head = typecast(single(A(1)), 'uint32');
%             if bitshift(head, -16) == hex2dec(MAGIC)
%                 num_chan = bitand(head, 2^16-1);
%            
%                 disp(['number of channels ' num2str(num_chan)])
%                 data = A(2:end)
% 				
%                 %data = typecast(int32(A(2:end)), 'single') %convert to single
%                 %process data
%             end
%         else
%             break
%         end
%     
%         i = i + 1;
%     end
% end
% 
% if bWrite
%     disp('sending data')
%     NPACKETS = 16;
% 
%     disp('writing header')
%     header = hex2dec([MAGIC, CMD_SEND_DATA, dec2hex(NPACKETS)])
% 
%     count = 0
%     while 1
%         fakeval = mod(count, 10);
%         data = fakeval:NPACKETS+fakeval;
%         data = int32(data)
%     
%         disp(['sending packet ' num2str(count)]);
%         fwrite(u, [header, data], 'int32');
%     
%         pause(0.2)
%         count = count + 1;
%     end
% end




















































