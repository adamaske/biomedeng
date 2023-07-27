#---- CONNECT TO EEG STREAM OVER NETWORK----

#----WHAT ARE WE LOOKING FOR ? -------

#----THREADS PER CATEGORY?? -----

#----CONNECT TO UNITY -----

#----NEEDS CALIBRATION PHASE----
    #-Tell the user to relax
    #-Record baseline EEG during relaxation for the emotion calulations

#----GET START SIGNAL FROM UNITY----

#----RECORD EEG STREAM------


#----(THREADS?) 
segment_time = 1#HOW LONG SHOULD A MEASUREMENT OF BAND POWER CONSIST OF
sample_rate = 125#HOW FAST IS THE EEG RECORDING ? ---- MAKE THIS DYNAMIC WHILE ITS RUNNING ----
num_samples = segment_time * sample_rate#HOW MANY SAMPLES DOES ONE SEGMENT CONSIST OF


#---- HANDLE EMOTION RECOGNITION-----
    #--- Compare average band power to the baseline
    #--- Score is the baseline - current * scale_factor
def Valiance():
    score = 0
    print(f"Valiance : {score:.1f}")

def Arousal():
    score = 0
    print(f"Arousal : {score:.1f}")

#--- MACHINE LEARNING ? -----
    #- Limited by the amount of data we can feed it
    #- Needs alot of data per emotion we want to track