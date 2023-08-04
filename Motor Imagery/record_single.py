#--- Record single instances of MI recordings ----- 
import mi_info
import user

from collections import deque

import time
import numpy as np

from pylsl import StreamInlet
from pylsl import resolve_stream
#What user is doing the recording ? 
labels = mi_info.labels
    

def Record_Single():
    data = np.zeros((5,5,5))
    
    num_samples = mi_info.num_samples # How many samples should we record ? 
    
    
    
    return data

if __name__ == "__main__":
    
    print(f"Welcome to Motor Imagery recording!")
    
    #--- SIGN INTO USER ------
    active_user = user.Sign_Into_User()
    username = active_user.Get_Name()
    
    print(f"Welcome {username}!")

    #-- Connect to OpenBCI GUI ----
    print("Connecting to LSL Stream!")
    inlet = StreamInlet(resolve_stream('type', 'EEG')[0])#Resolves the 0th stream of type EEG
    print("Connection Established!")
    
    
    #--- PROGRAM MAIN LOOP ----
    running = True
    while running:
        
        #---- DISPLAY USER INFO ----
        # user.Refresh_User(username) refresh user 
        
        
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
    
        # Command Chosen
        print(f"Inlet rate {inlet.info().nominal_srate()}")
        #Do recording
        num_samples = mi_info.num_samples
        recording_time = mi_info.recording_time
        sample_rate = inlet.info().nominal_srate()
        channels = mi_info.channels
        
        start_time = time.time()
        
        channel_data = {} 
        
        last_print = time.time()
        fps_counter = deque(maxlen=150)
        duration = 5
        for sample in range(duration):#0 - 625
            
            for channel in range(channels):
                data, timestamp = inlet.pull_sample()
                if channel not in channel_data:
                    channel_data[channel] = data
                else:
                    channel_data[channel].append(data)
                    
            fps_counter.append(time.time() - last_print)
            last_print = time.time()
            cur_raw_hz = 1/(sum(fps_counter)/len(fps_counter))
            print(cur_raw_hz)   
                    
           
        
        array = np.array(channel_data)
        print(array.shape)
        elapsed_time = time.time() - start_time
        print(f"Elapsed time : {elapsed_time} seconds")
        
        
        #Save or Discard ? 
        
        print("Keep or Discard this recording?")
        answer = input(f" [K] to Keep / [D] for Discard : ")
        
        if str(answer).capitalize() == "K":
            user.Save_FFT_Data_To_User(username, label, data)
        elif str(answer).capitalize == "D":
            keep = False

        
        
    
    print("Shutdown")
    exit()