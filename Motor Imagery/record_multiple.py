#---- RECORD MI COMMANDS ------
import random
import time

import numpy as np

import matplotlib
import matplotlib.pyplot as plt

from pylsl import StreamInlet
from pylsl import resolve_stream

import user as ud



# ---- SETUP VISUALS ------
fontsize = 30 #fontsize
matplotlib.rcParams.update({'font.size': fontsize})#set font size

fig, ax = plt.subplots() #figure and axes
fig.set_facecolor('black')#black background color
ax.set_xlim(-1, 1)#axis goes from -1 to 1
ax.set_ylim(-1, 1)
ax.axvline(0, color='red')#Vertical red line
ax.axhline(0, color='red')#Horizontal red line

box_x_size = 0.4#box size
box_y_size = 0.4
box = plt.Rectangle((-box_x_size / 2, -box_y_size / 2), box_x_size, box_y_size, facecolor='blue', edgecolor='white')#Box that moves with the class being trained left, right etc. 
ax.add_patch(box)#add box to axe

trial_text = ax.text(0, 1, 'Trail', ha='center', va='bottom', color='white')#text object, shows what direction
class_text = ax.text(0,-1, 'DIRECTION', ha='center', va='bottom', color='red')#shows the current class being performed
next_trial_text = ax.text(0, -0.5, 'NEXT TRIAL', ha='center', va='bottom', color='green')#shows the next trial to be done, shown in waiting period

plt.ion() #enables interactive mode
plt.draw()
plt.show()

#--- LSL ---
print('Connecting to EEG stream')
inlet = StreamInlet(resolve_stream('type', 'EEG'))
print('Connceted!')

#--- EEG ---
channels = 16 #how many channels are there 
recording_time = 5#How long does one sample last ? 

sample_rate = 125#inlet.info().nominal_srate()
                    #125hz recording for 16 channel, 250hz for 8 channels
max_fft_hz = 60

#---- TRIALS ----
actions = ['Forward', 'Backward', 'Left', 'Right']
#
warmup_trials = 5 #Amount of warmup trails. A warmup trial does not count in calibartion
trails_per_class = 20 #Amount of trials per class (left / right) 
trial_time = 3.5 #How long does one trial last, in seconds
wait_time = 0.5 #How long to wait between each trial
pause_every =100 #After x trails, give the user a break
pause_duration = 5 #How long the trail last


labels = ['Forward', 'Backward', 'Left', 'Right']#, 'up', 'down', 'forward', 'backward'] #The marker being sent, this must correspond with targets in NeuroPype Pipline(found in "assign targets" module)
box_directions = [[-1, 0, 0], [1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]]#What x,y and z direction does the box move per label


#Make choice before trial starts so that we can display next choice in waiting period
def Choose_Random_Label():
    return random.choice(range(len(labels) * 10)) % len(labels)

choice = Choose_Random_Label() #Is this a left or right trail? Left and Right trials must be in a random order for machine learning. 
                                                                #If not the ML will learn the temporal features
                                                                

trial_amount = warmup_trials + (trails_per_class * len(labels)) #total amount of trails to run. Warmups + 60 left + 60 right,etc        

#--- DATA RECORDED ---
fft_data = np.zeros(0, int(trial_time * sample_rate), int(channels), int(max_fft_hz))#stores the fft data for each trial
                                                                                     #Each trial has 3.5s * 125hz samples = 438 samples
                                                                                    #each samples has 16 channels
                                                                                    #each channel is an array with the fft magnitudes from 0 to 60 hz, f.example [0, 0,0, 0.1, 0.4, 0.7, 0.3, ..., 3.6]
fft_labels = []#the first trail, fft_data[0] is a trial for fft_labels[0], for example the first trial recorded is for Forward, then fft_lables[0] = Forwards

#------ TRIALS THAT RECORD FFT DATA WHILE THE USER IS DOING MOTOR IMAGERY ------
start = input("Anykey to start")
for trial in range(1, trial_amount + 1): #Trial loop. Starts at 1 for simplicity
    
    trial_text.set_text(f"Trail : {trial}")#update trial text to correct trial
    class_text.set_text(f"{labels[choice].capitalize()}")#update class text to the current calibartion class
    
    if trial < warmup_trials: #This is a warmump trial
        trial_text.set_text(f"Warmup : {trial}")#update trial text to correct trial
    
    if trial == warmup_trials: #Warmups are finsihed 
        print('Warmups are finsihed!')
        print('Calibration starts trials now!')
        #outlet.push_sample(['calib-begin']) #Send "Start calibration marker". This string must correspond to the "Begin Calibration" marker in NeuroPype
        
    if trial > warmup_trials: #Trial for calibration
        marker = labels[choice]#The marker to send / What class is this trial (right / left)
        #outlet.push_sample([marker])#Send the string through outlet
        print(f"Trial {marker.capitalize()} started!")
    
    next_trial_text.set_visible(False)#the trail is starting, hide the next_trial text
    
    #reset the box
    width =   box_x_size#get size of box
    height =  box_y_size#for example (2,2)
    direction_to_move = box_directions[choice]#what direction are we moving the box, based on choice
    
#--- MAIN TRIAL LOOP ---
    start_time = time.time() #time the trial started
    #TODO save the incoming lsl stream while this is ongoing
    #How many times de we want input from the LSL stream for one trial ? 
    num_samples = trial_time * sample_rate
    for data_point in range(int(num_samples)):
        data, sample = inlet.pull_sample()
        data#Contains 16 channels of FFT data, from 0-60 Hz. Therefore this is a (16, 60) array

    while time.time() - start_time < trial_time: #current trial loop
        time_percentage =  (time.time() - start_time) / trial_time#how much of the trial time has gone
        
        box_x =direction_to_move[0] * time_percentage #move along axis by time
        box_y =direction_to_move[1] * time_percentage 
        
        box.set_width (width  + (direction_to_move[2] * time_percentage)) #height = 2, box dir [3] = -1, time per = 0.5, new height = 2 + (-1 * 0,5) = 1.5 #this means move away from screen 
        box.set_height(height + (direction_to_move[2] * time_percentage)) #this changes the size of the box, bigger for forward, smaller for backward. 
        
        box.set_xy((box_x - (box.get_width()/ 2), box_y - (box.get_height() / 2))) #set new box position, pivot is bottom left, so minus half box size to align on axis properly
        
        fig.canvas.draw_idle() #redraw
        fig.canvas.flush_events() #flush
        
        print(f"Performing : {time.time()-start_time:.1f}", end='\r') #display how long into performing it is

    print(f"Finsihed Trial : {labels[choice].capitalize()}!")
#--- TRIAL LOOP ENDED ---

    
    choice = Choose_Random_Label()# Choose new label for the next trial
    
    print(f"Next Trial is for {labels[choice].capitalize()}!")

    #shown next trail task
    next_trial_text.set_text(f"Next trail : {labels[choice].capitalize()}")
    next_trial_text.set_visible(True)
    
    fig.canvas.draw()
    fig.canvas.draw_idle() #redraw
    fig.canvas.flush_events() #flush
    start_time = time.time() #what time the waiting starts

#--- WAIT LOOP ---
    while time.time() - start_time < wait_time:#waiting loop
        print(f"Waiting : {time.time()-start_time:.1f}", end='\r')
#--- WAIT COMPLETE ---

#--- PAUSE LOOP ---
    if trial % pause_every == 0: #Check if we should pause
        print(f"Pausing for {pause_duration:.1f} seconds!")
        start_time = time.time()
        while time.time() - start_time < pause_duration:
            print(f"Paused : {time.time()-start_time:.1f}", end='\r')
#----- ALL TRIALS COMPLETE ------
                                            
                                            
                                            
#--- SAVE THE RECORDED DATA ---

#- Save numpy file with the arrays of fft_data

#- Save json files with the labels and information about the recording of the trials