#---- SEND PREDICTION THORUGH UDP -----
import socket

UDP_IP = "127.0.0.1"
UDP_PORT = 5005
MESSAGE = b"Hello, World!"

print("UDP target IP: %s" % UDP_IP)
print("UDP target port: %s" % UDP_PORT)
print("message: %s" % MESSAGE)

#AF = address family spec(AF_INET is for UDP and TCP)
#type = The type spec for the new socket, SOCK_STREAM for TCP, SOCK_DGRAM for UDP
#protocol = The protocol which is being used(IPPROTO_TCP for tcp)
#Create this socket, UDP-TCP, UDP
sock = socket.socket(socket.AF_INET, #AF    
                     socket.SOCK_DGRAM) # UDP
sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))