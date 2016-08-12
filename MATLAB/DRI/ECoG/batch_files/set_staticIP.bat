@ECHO OFF
ECHO Set static IPv4 address for PC 
ECHO to communicate with RZ box
ECHO Unplug NIC cable before running
netsh int ipv4 set address name="Ethernet" source=static address=10.1.0.10 mask=255.255.255.0