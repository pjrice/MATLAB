%Establish the data to send, and count the number of values being sent
%(fread expects this #vals as input argument; in the case of matlab -> TDT,
%matlab isn't receiving, so unnecessary)
data = 1:50;
numvals = length(data);

%start echo server, establish udp object
%echo server only for playing with myself ;)
echoudp('on', 4012)
udpobj = udp('127.0.0.1', 4012);

%default output buffer size is 512 bytes, make sure the I/O buffers are large
%enough to handle the data being sent/received
%must set before object is open
udpobj.OutputBufferSize = 8000; %in bytes
udpobj.InputBufferSize = 8000;

%open udp object
fopen(udpobj)

%write/read data
%MAKE SURE THIS OPERATES ASYNCRHONOUSLY - otherwise writing data will block
%the command line until the operation completes or timeout occurs
fwrite(udpobj,data,'int8','async');
data_rec = fread(udpobj,numvals,'int8');

%shut down echo server and close object
echoudp('off')
fclose(udpobj)





