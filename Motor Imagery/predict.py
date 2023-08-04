
from pylsl import StreamInlet
from pylsl import resolve_stream

import numpy as np
import tensorflow as tf
import mi_info

#---- SORT THE DATA -----

#-- Load EEG Streams --
inlet = StreamInlet(resolve_stream('type', 'EEG')[0])#Resolves the 0th stream of type EEG

#-- Load Model ----
model_name = "Whatever you called the model + path to it"
model = tf.keras.models.load_model(model_name)

#---- GET FFT FROM OPENBCI GUI ----
sample, timestamp = inlet.pull_sample()
channel_data = np.zeros((16, 60))

#-- Format Data --- 
model_input = np.array(channel_data).reshape((-1, 16, 60))

#---- PASS THORUGH TRAINED ML MODEL -----
model_output = model.predict(model_input)


labels = mi_info.labels
prediction = 0 

#---- SEND PREDICTION THORUGH UDP -----
import socket

UDP_IP = "127.0.0.1"
UDP_PORT = 5005
MESSAGE = labels[prediction].encode('utf-8')

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
