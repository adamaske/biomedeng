import json
import pathlib
import numpy
import os

max_files_per_command = 100

def Current_Dir():
    return pathlib.Path(__file__).parent#get current folder

def Users_Folder():
    return os.path.join(Current_Dir(), "Users")

def User_Folder(user="Adam"):
    return os.path.join(Users_Folder(), user)

def User_Label_Folder(user, label):
    return os.path.join(User_Folder(user), label)

def Load_All_Users():
    
    users = []
    for file in os.listdir(Users_Folder()):
        print(file)
        user_name = file
        users.append(Load_User(user_name))
    
    #all users all loaded
    
    return users

def Load_User(user="Adam"):
    print(f'Loading User : {user}')
    
    user_folder_path = User_Folder(user)#This is the users main folder where all their data is stored

    #load all their numpy arrays of fft data
    
    #load all their json files

def Sort_Users_Files(user):
    print(f"Sorting {user}")
    path = User_Folder(user)
    for label in os.listdir(path):#this should find all the folders with fft data in them, for example left and right if the user only trained those
        command_folder_path = os.path.join(path, label)
        if not os.path.isdir(command_folder_path):#if the file found is not a directroy, contiue the next file
            continue
        #--- Sorting can be done ---- The folder labeled with this command exists
        #for each numpy array file, there should be a corresponding json file
        npy_files = []
        json_files = []
        for file in os.listdir(command_folder_path):
            file_name = file# for example 0, 1, 2, 3 etc. 
            
            npy_files.append(file_name)
            
    
    

def Save_FFT_Data_To_User(user, label, fft_data):#"Forward", numpy array
    print("Saved")
    folder_path = User_Label_Folder(user,label)
    if not os.path.isdir(folder_path):
        os.mkdir(folder_path)
        
    #the folder now definetly exists
    
    #find where to place the fft data
    
    #resort the already existing files
    Sort_Users_Files(user)
    
    
#Load_User("Aske")
Load_All_Users()