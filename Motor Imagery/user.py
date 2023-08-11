import json
import pathlib
import numpy as np
import os
import time
import mi_info

max_files_per_command = 100

class Label_Count():
    def __init__(self, label, count):
        self.label = label
        self.count = count
        
class User_Data:
    def __init__(self, name,labels, counts):
        self.name = name
        self.labels = labels # What commands are avaiable
                            #["None", "Forward", ...]
        self.counts = counts # How many of recordings of each command do we have
                            #[3, 1, ...]
    
    def Get_Name(self):
        return self.name
    def Set_Name(self, name):
        self.name = name
        
    def Get_Labels(self):
        return self.labels
    def Set_Labels(self, labels):
        self.labels = labels
   
    def Get_Counts(self):
        return self.counts
    def Set_Counts(self, counts):
        self.counts = counts
        
    
def Get_Time_Date(): #this function returns the first avaibale filename for the file 
    timestr = time.strftime("%Y%m%d-%H%M%S")
    return timestr

def Current_Dir():
    return pathlib.Path(__file__).parent#get current folder

def Users_Folder():
    return os.path.join(Current_Dir(), "Users")

def User_Folder(user="Adam"):
    path = os.path.join(Users_Folder(), user)
    if not os.path.isdir(path):
        os.mkdir(path)
        print(f"Made directory for {user}!")
    return path

def User_Label_Folder(user, label):
    path = os.path.join(User_Folder(user), label)
    
    if not os.path.isdir(path):
        os.mkdir(path) 
        print(f"Made {label} folder for {user}!")
        
    return path

def Load_All_Users():
    
    users = []
    for file in os.listdir(Users_Folder()):
        print(file)
        user_name = file
        users.append(Load_User(user_name))
    
    #all users all loaded
    
    return users

def Get_User_Counts(username):
    labels = mi_info.labels
    
    counts = []#files per label
    for label in labels:# for every label
        path = User_Label_Folder(username, label) #folder path to this label

        count = 0
        if os.path.isdir(path): #does this folder exist ? 
            count = len(os.listdir(path))

        counts.append(count)
    return counts

def Load_User(username="Adam"):
    
    
    user_folder_path = User_Folder(username)#User's folder

    labels = mi_info.labels#The labels avaiable
    
    counts = Get_User_Counts(username)
            
    counts_array = np.array(counts)
    
    data = User_Data(username, labels, counts)
    data.Set_Name(username)
    data.Set_Labels(labels)
    data.Set_Counts(counts)    
    
    print(f'Loaded User : {username}')
    return data

def Sign_Into_User():
    print(f"Sign in with username (Case Sensitive)")
    username = input("Username : ")
    
    user = Load_User(username)
    
    print("Signed In")
    Display_Profile(user)
    
    return user
     
def Refresh_User(user):
    
    username = user.Get_Name()
    
    labels = mi_info.labels
    user.labels = labels
    
    fresh_counts = Get_User_Counts(username)
    user.counts = fresh_counts
    
    return user
     
def Sort_Users_Files(user):
    print(f"Sorting {user}")
    path = User_Folder(user)
    
    for label in os.listdir(path):#this should find all the folders with fft data in them, for example left and right if the user only trained those
        command_folder_path = os.path.join(path, label)
        
        if not os.path.isdir(command_folder_path):#if the file found is not a directroy, contiue the next file
            print(f"{user} has no {label} directory!")
            continue
        #--- Sorting can be done ---- The folder labeled with this command exists
        #for each numpy array file, there should be a corresponding json file
        npy_files = []
        json_files = []
        for file in os.listdir(command_folder_path):
            file_name = file# for example 0, 1, 2, 3 etc. 
            
            npy_files.append(file_name)
            
    
def Debug_FFT_Data(fft_data):
    print(f"FFT Data Shape : {fft_data.shape}")
    

def Save_FFT_Data_To_User(user, label, fft_data):#user : "Adam", "Meisam", etc....
                                                 #label : "Right", "Left", etc....
                                                 #fft_dat : numpy array with the fft data
    print(f"Saving {user}'s {label} FFT-Data") 
    
   #Sort_Users_Files(user) # THIS IS NOT NEEDED WHEN USING TIMESTAMPS FOR FILENAME
    
    folder_path = User_Label_Folder(user, label)#where to save the data
    
    file_name = "fft_" + Get_Time_Date()#files are saved with the current date and time
    
    file_path = os.path.join(folder_path, file_name)
    
    data = np.array(fft_data)#create numpy array
    Debug_FFT_Data(data)# check the array shape

    np.save(file_path, data)
    print(f"Saved {user}'s {label} data at {file_path}")
    
    return file_path
    
def Display_Profile(user):
    
    username = user.Get_Name()
    labels = user.Get_Labels()
    counts = user.Get_Counts()
    
    print(f"Motor Imagery Profile : {username}")
    print("------------------------------------")
    for i in range(len(labels)):
        label = labels[i]
        count = counts[i]
        print(f"{label} : {count}")
    print("------------------------------------")
    print()

def Get_User_FFT_Data(user):
    
    username = user.Get_Name()

    labels = mi_info.labels
    
    counts = user.Get_Counts()
    print("------------------------------------")
    print(f"Loading {username}'s FFT data : ")
    # --- LOAD ALL NUMPY ARRAYS FROM FILE -----
    arrays = [[] for i in range(len(labels))]
    for i in range(len(labels)):
        label = labels[i]
        
        path = User_Label_Folder(username, label)
        
        for file in os.listdir(path):
            data = np.load(os.path.join(path, file))
            arrays[i].append(data)
   
   
   # --- SORT FILES INTO SINGLE ARRAY ----
    labels_data = [[] for i in range(len(mi_info.labels))]#
    
    for i in range(len(labels)):
        label = labels[i]
        array = arrays[i]
        
        label_data = np.empty((0, mi_info.channels, mi_info.max_fft_hz))
        for recording in array:
            #recording_data = recording.reshape((1, len(recording), mi_info.channels, mi_info.max_fft_hz))
            for sample in recording:
                sample_data = sample.reshape((1, mi_info.channels, mi_info.max_fft_hz))
                label_data = np.vstack((label_data, sample_data))
      
        print(f"Label : {label}, Count : {len(array)}, Shape : {label_data.shape}")
        
        labels_data[i] = label_data
    
    print("------------------------------------")
    print()
    return labels_data
    
def filter_fft(data):
        
    return 0
 
def Save_Model(user, model):
    model = 0
    

def Load_Model(user, index):
    k =0

def Save_Model(user, model):
    
    models_path = os.path.join(pathlib.Path(__file__).parent, "Models")
    

def Get_User_Models(user):
    
    username = user.Get_Name()
    
      
#Load_All_Users()