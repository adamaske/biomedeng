import mi_info
import user

from pylsl import StreamInlet
from pylsl import resolve_stream

import time
import numpy as np
from threading import Thread
import socket

import tensorflow as tf

from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix


class PredictionThread:
    def __init__(self, *args):
        Thread.__init__(self)
        self.name = args[0]
        self.socket = args[1]
        self.canceled = False
    def run(self):
        
        
        return

def Display_UDP(predictor):
    
    print("UDP target IP: %s" % predictor.UDP_IP)
    print("UDP target port: %s" % predictor.UDP_PORT)
    
    return 0 

class Predictor:
    
    def __init__(self):
        self.username = "Adam"
        self.active_user = 0
        self.UDP_IP = "127.0.0.1"
        self.UDP_PORT = 5005
        
        self.models = []
        self.inlet = 0
        
    
    def Setup(self):
        print(f"Predictor : Setup")
        #-- SIGN IN ---
        self.active_user = user.Load_User(self.username)
        
        #-- SET NETWORKING --
        self.UDP_IP = "127.0.0.1"
        self.UDP_PORT = 5005
        self.socket = socket.socket(socket.AF_INET, #AF    
                         socket.SOCK_DGRAM) # UDP
        Display_UDP(self)
        
        #-- LOAD MODEL --
        self.model = user.Load_Model(self.active_user, 0)#user with name, model index
        
         #-- Load EEG Streams --
        self.inlet = StreamInlet(resolve_stream('type', 'EEG')[0])#Resolves the 0th stream of type EEG

        print(f"Predictor : Setup Complete")
        
     
    #---- SEND PREDICTION THORUGH UDP -----
    def Send_Prediction_UDP(self, prediction):
        print(f"prediction : {prediction} , {mi_info.labels[mi_info.active_labels[int(prediction)]]}")
        #MESSAGE = mi_info.labels[prediction].encode('utf-8')

        #self.socket.sendto(MESSAGE, (self.UDP_IP, self.UDP_PORT))      
          
    def Record(self):
        
        print(f"Predictor : Recording started...")
        recording_time = 30
        start_time = time.time()
        self.inlet.flush()
        while time.time() - start_time < recording_time:
            
            segments = np.empty((mi_info.segment_length, mi_info.channels, mi_info.max_fft_hz))
            for segment in range(mi_info.segment_length):
                
                segment_data = np.empty((mi_info.channels, mi_info.max_fft_hz))
                
                for channel in range(mi_info.channels):
                    sample, timestamp = self.inlet.pull_sample()
                    
                    sample_array = np.array(sample[:mi_info.max_fft_hz])
                    segment_data[channel] = sample_array

                segments[segment] = segment_data
            
            #print(f"segments : {segments.shape}")
            self.Predict(segments)  
        
        print(f"Predictor : Recording complete.")
    
    def Predict(self, channel_data):
        #-- Format Data --- 
        model_input = np.array(channel_data).reshape((-1, mi_info.segment_length, mi_info.channels, mi_info.max_fft_hz))
        model_input /= np.max(model_input)
        #print(f"model_input : {model_input.shape}")
        
        #---- PASS THORUGH TRAINED ML MODEL -----
        model_output = self.model.predict(model_input)
        
        model_output = model_output.argmax(axis=-1)
        correct_output = 0
        #print(f"correct_output : {correct_output}")
        #print(f"model_output : {model_output}")
        
        prediction = model_output
        self.Send_Prediction_UDP(prediction)
       # pred = model.predict(x_val)
        #pred_y = pred.argmax(axis=-1)
        #cm = confusion_matrix(y_val, pred_y)
        #print(cm)  
        

       
    

 
    

    
   
if __name__ == '__main__':
    
    predictor = Predictor()
    
    predictor.Setup()
    
    predictor.Record()
    
    print(f"Shutdown")
    
    exit()
