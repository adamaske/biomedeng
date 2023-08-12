#---- CALIBRATION -----
#aka Train the ML model and save it to disk
import user
import os
import pathlib
import time
import numpy as np
import mi_info

from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
import tensorflow as tf

#from tensorflow.python.keras.models import Sequential
#from tensorflow.python.keras.layers import Dense, Dropout, Activation, Flatten
#from tensorflow.python.keras.layers import Conv1D, MaxPooling1D#, BatchNormalization


#---- LOAD USER ------
username = "Adam"

active_user = user.Load_User(username)

#--- LOAD ALL FFT DATA FOR USER ----
fft_data = user.Get_User_FFT_Data(active_user)

#---- SEGMENTING -------


#The data needs to be sliced up into segments which somewhat overlap
#Get all right data
label_ids = np.array((0,1,2,3,4))
active_labels= mi_info.active_labels#---_ DEFINES WHAT LABELS WILL BE TRAINED ON. 0 = neutral, 1 = forward, etc...


segment_overlap = 0

labels = []

data = np.empty((0, mi_info.segment_length, mi_info.channels, mi_info.max_fft_hz))

for label in active_labels:
    label_id = label_ids[label]
    
    label_data = fft_data[label_id] #all the data in the users LEFT folder
    #print(f"label_data : {label_data.shape}")
    
    num_samples = len(label_data)
    overlap = int(mi_info.segment_length * segment_overlap)
    
    for start in range(0, num_samples, mi_info.segment_length - overlap):
        end = start + mi_info.segment_length
        segment = label_data[start:end]
        
        if len(segment) == mi_info.segment_length:
            reshaped_segment = segment.reshape((1, mi_info.segment_length, mi_info.channels, mi_info.max_fft_hz))
            data = np.vstack((data, reshaped_segment))
            labels.append(label_ids[label])#add the corresponding label each time we add a segment


print(f"data : {data.shape}")
print(f"labels : ")
label_data = np.zeros((len(labels)))
for i in range(len(labels)):
    label  = float(labels[i])
    label_data[i] = label / float(3)
label_data = np.array(labels)
#print(f"label_data : {label_data.shape}")
data_len = len(data)
label_len = len(labels)
fourth_of_data = data_len / 4
fourth_of_label = int(label_len / 4)
#---- SETUP ----...
#    >>> X_train
#    array([[4, 5],
#           [0, 1],
#           [6, 7]])
#    >>> y_train
#    [2, 0, 3]
#    >>> X_test
#    array([[2, 3],
#           [8, 9]])
#    >>> y_test
#    [1, 4]

x_train,  x_val, y_train, y_val = train_test_split(data, label_data, train_size=0.5, test_size=0.5, random_state=None, shuffle=True)
print(f"x_train : {x_train.shape}")
print(f"x_val : {x_val.shape}")
print("-------")
print(y_train)
print(y_val)
x_train = x_train.reshape(-1, mi_info.segment_length, mi_info.channels, mi_info.max_fft_hz)
x_val = x_val.reshape(-1, mi_info.segment_length, mi_info.channels, mi_info.max_fft_hz)

x_train /= np.max(x_train)
x_val /= np.max(x_val)

#-- create model --
model = tf.keras.models.Sequential([
    tf.keras.layers.Conv2D(64, (2,2), activation='relu', input_shape=x_train.shape[1:], padding='same'),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.MaxPooling2D(),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(len(active_labels), activation='softmax'),
])

# Compile the model
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
# Print model summary
model.summary()

#loss, acc = model.evaluate(x_val, y_val, verbose=2)
#print("Untrained model, accuracy: {:5.2f}%".format(100 * acc))

model.fit(x_train, y_train, batch_size=16,epochs=100, verbose="auto", validation_data=(x_val, y_val))

# Re-evaluate the model
loss, acc = model.evaluate(x_val, y_val, verbose=2)
print("Restored model, accuracy: {:5.2f}%".format(100 * acc))

pred = model.predict(x_val)
pred_y = pred.argmax(axis=-1)
conf_matrix = confusion_matrix(pred_y, y_val)
print(f"conf_matrix :")
print(f"y_val : {y_val}")
print(f"y_pred : {pred_y}")
print(conf_matrix)

#---- SAVE MODEL -----
answer = input(f"Save this model? [K] to Keep / [D] to Discard : ")
if str(answer).capitalize() == "K":
    
    path = user.Save_Model(active_user, model)
elif str(answer).capitalize() == "D":
    x = 0
    print(f"Not Saved...")
else:
    print(f"Not recongized answer, saving model...")
    
    

#models_path = os.path.join(pathlib.Path(__file__).parent, "Models")
#model_name = username + "--" + user.Get_Time_Date()
#user_models_path = #os.path.join(models_path, model_name)
#model.save(user_models_path)
