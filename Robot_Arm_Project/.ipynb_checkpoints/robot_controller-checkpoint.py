from serial import Serial
import time

arduino = Serial(port='COM8', baudrate=115200, timeout=.1) 

def sleep():
    time.sleep(0.05)
def write_read(x):
    arduino.write(bytes(x, 'utf-8'))
    sleep()
    data = arduino.readline()
    
    return data

while True:
    num = input("Enter a number : ")    # taking input from user
    
    value = write_read(num)
    
    print("value")
    
    