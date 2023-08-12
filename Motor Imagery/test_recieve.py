#---- RECEIVING THE UDP MESSAGES ----
#this is for testing currently

import time
import socket

UDP_IP = "127.0.0.1"#local host
UDP_PORT = 5005#what port are we listening to

sock = socket.socket(socket.AF_INET, # Create socket
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))# binds socket to the ip and 

print('Started Listening')
while True:
    data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
    msg_recived = data.decode()
    print("Received message: %s" % msg_recived)
print('Ended Listening')