#---- CALIBRATION -----
#aka Train the ML model and save it to disk
import user

import time
import numpy as np

#import tensorflow as tf
#
#from tensorflow.python.keras.models import Sequential
#from tensorflow.python.keras.layers import Dense, Dropout, Activation, Flatten
#from tensorflow.python.keras.layers import Conv1D, MaxPooling1D, BatchNormalization


#---- LOAD USER ------
username = "Adam"

active_user = user.Load_User(username)

#--- LOAD ALL FFT DATA FOR USER ----
fft_data = user.Get_User_FFT_Data(active_user)

exit()
#---- SEGMENTING -------

#The data needs to be sliced up into segments which somewhat overlap




#---- SETUP ----
train_X = 0
train_y = 0
test_X = 0
test_y = 0

model = Sequential()

model.add(Conv1D(64, (3), input_shape=train_X.shape[1:]))
model.add(Activation('relu'))

model.add(Conv1D(64, (2)))
model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=(2)))

model.add(Conv1D(64, (2)))
model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=(2)))

model.add(Flatten())

model.add(Dense(512))

model.add(Dense(3))
model.add(Activation('softmax'))

model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])

epochs = 10
batch_size = 32
for epoch in range(epochs):
    model.fit(train_X, train_y, batch_size=batch_size, epochs=1, validation_data=(test_X, test_y))
    score = model.evaluate(test_X, test_y, batch_size=batch_size)
    #print(score)
    MODEL_NAME = f"new_models/{round(score[1]*100,2)}-acc-64x3-batch-norm-{epoch}epoch-{int(time.time())}-loss-{round(score[0],2)}.model"
    model.save(MODEL_NAME)