@ECHO OFF
ECHO Revert IPv4 to obtaining 
ECHO IP automatically after 
ECHO communicating with RZ box
ECHO over UDP
netsh interface ipv4 set address name="Ethernet" source=dhcp