#--- Record single instances of MI recordings ----- 
import mi_info
import user

from collections import deque
import matplotlib.pyplot as plt
import time
import numpy as np

import pylsl 
from pylsl import StreamInlet
from pylsl import resolve_stream
import os

import socket
#What user is doing the recording ? 
labels = mi_info.labels
    

def Record_Single():
    data = np.zeros((5,5,5))
    
    num_samples = mi_info.num_samples # How many samples should we record ? 
    
    
    
    return data

def Run():
    print(f"Welcome to Motor Imagery recording!")
    
    #--- SIGN INTO USER ------
    active_user = user.Sign_Into_User()
    username = active_user.Get_Name()
    
    print(f"Welcome {username}!")

    #-- Connect to OpenBCI GUI ----
    print("Connecting to LSL Stream!")
    inlet = StreamInlet(resolve_stream('type', 'EEG')[0])#Resolves the 0th stream of type EEG
    print("Connection Established!")
    
    #nlet.close_stream()
    
    #--- PROGRAM MAIN LOOP ----
    running = True
    while running:
        
        #---- DISPLAY USER INFO ----
        active_user = user.Refresh_User(active_user)
        
       
        user.Display_Profile(active_user)
    
        print("What do you want to train ?")
        
        for index in range(len(labels)):#Display the commands which can be trained. 
            print(f"{index}. {labels[index]}")
        print(f"[ E ] for Exit")#Exit the application
        
        answer = input(f"Input [0 - {len(labels) - 1}] : ")#Get answer from user
        
        if str(answer).capitalize() == "E":#Check for Exit prompt
            print("Exiting!")
            running = False
            break
        
        label_index = int(answer) # Cast answer to int.
        
        label = labels[label_index]#Find chosen label
        print(f"You choose {label}!")
        
        #---- COUNTDOWN------
        countdown_amount = 3
        for i in range(countdown_amount):
            print(f"Starting in {countdown_amount - i} seconds....")
            time.sleep(1)
        print(f"GO!")  
        
        
        #---- RECORDING ------
        num_samples = mi_info.num_samples
        recording_time = mi_info.recording_time
        sample_rate = inlet.info().nominal_srate()#mi_info.sample_rate
        channels = mi_info.channels
        num_samples = int(recording_time * sample_rate)
        start_time = time.time()
        
        print(f"Flushed samples : {inlet.flush()}") # -- VERY IMPORTANT --
        channel_data = [[] for i in range(channels)]
        while time.time() - start_time < recording_time:
            for channel in range(channels):
                sample, timestamp = inlet.pull_sample()
                channel_data[channel].append(sample)
                
       
        elapsed_time = time.time() - start_time
        print(f"Elapsed time : {elapsed_time} seconds")       
        
        fft_data = np.array(channel_data)
        print(f"FFT Data: {fft_data.shape}")
        print(f"Sample Rate : {int(len(fft_data[0]) / recording_time)}")
   
        #------- KEEP or DISCARD --------- 
        print("Keep or Discard this recording?")
        answer = input(f"[K] to Keep / [D] to Discard : ")
        if str(answer).capitalize() == "K":
            user.Save_FFT_Data_To_User(username, label, fft_data)
        elif str(answer).capitalize == "D":
            keep = False
        else:
            print(f"Not recoginzed, the recording will be saved. Navigate to the folder and delete it manually")
            user.Save_FFT_Data_To_User(username, label, fft_data)
       
    
    
    
if __name__ == "__main__":
    Run()   
    print("Shutdown")
    exit()