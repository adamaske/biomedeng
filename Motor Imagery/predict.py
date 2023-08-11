
from pylsl import StreamInlet
from pylsl import resolve_stream

import numpy as np
import tensorflow as tf
import mi_info
import user
import os
import pathlib
from threading import Thread
import socket


from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix


class ExitThread:
    def __init__(self, *args):
        self.canceled = False
    def run(self):
        
        
        return 
class PredictionThread:
    def __init__(self, *args):
        Thread.__init__(self)
        self.name = args[0]
        self.socket = args[1]
        self.canceled = False
    def run(self):
        
        
        return

def Setup():
    x=0
    
       
    
#---- SEND PREDICTION THORUGH UDP -----
def Send_Prediction_UDP(prediction):
    UDP_IP = "127.0.0.1"
    UDP_PORT = 5005
    MESSAGE = mi_info.labels[prediction].encode('utf-8')

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

 
def Predict(model, channel_data):
    #-- Format Data --- 
    model_input = np.array(channel_data).reshape((-1, 16, 60))

    #---- PASS THORUGH TRAINED ML MODEL -----
    model_output = model.predict(model_input)
    
    labels = mi_info.labels
    prediction = 0 
   # pred = model.predict(x_val)
    #pred_y = pred.argmax(axis=-1)
    #cm = confusion_matrix(y_val, pred_y)
    print(cm)

    Send_Prediction_UDP(prediction)

def Run():
    #--- LOAD USER ----
    username = "Adam"
    active_user = user.Sign_Into_User(username)
    models_path = os.path.join(pathlib.Path(__file__).parent, "Models")
    user_models_path = os.path.join(models_path, username)

    model_names = []
    for file in os.listdir(user_models_path):
        model_names.append(file)

    if len(model_names) == 0:
        print(f"Found no TensorFlow-models for {username}!")
        print(f"Exiting...")
        return
        
    model_name = model_names[0]

    #-- Load EEG Streams --
    inlet = StreamInlet(resolve_stream('type', 'EEG')[0])#Resolves the 0th stream of type EEG

    #-- Load Model ----
    model_path = os.path.join(user_models_path, model_name)
    model = tf.keras.models.load_model(model_name)

    #---- GET FFT FROM OPENBCI GUI ----
    while True:
        sample, timestamp = inlet.pull_sample()
    sample, timestamp = inlet.pull_sample()
    channel_data = np.zeros((16, 60))

    #-- Format Data --- 
    model_input = np.array(channel_data).reshape((-1, 16, 60))

    


    labels = mi_info.labels
    prediction = 0 
    
    Send_Prediction_UDP(prediction)

   
if __name__ == '__main__':
    Setup()
    Run()
    exit()
