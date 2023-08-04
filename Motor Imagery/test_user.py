import user

import numpy as np
#Adam's folder
#print(user.User_Folder("Adam"))
##The folder containing Adam's Right - recordings data
#print(user.User_Label_Folder("Adam", "Right"))

#testing saving FFT recording

fake_fft_data = np.zeros((5, 5, 5))

file_path = user.Save_FFT_Data_To_User("Adam", "Left", fake_fft_data)

data = np.load(file_path + ".npy")
print(data.shape)