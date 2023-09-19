import serial
import time
from tkinter import *


class Position:# A position is a set of angles
    
    def __init__(self, base, shoulder, elbow, wrist, wrist_rotation, gripper) :
        self.angels = [0,0,0,0,0,0]
        self.angels[0] = base
        
    def fun():
        print("j")
        
class Braccio:
    def __init__(self, serial_port):
        self.port = serial.Serial(serial_port, 115200, timeout=5)
        time.sleep(3)
    def write(self, string):
        self.port.write(string.encode())
        self.port.readline()

    def move_to_position(self, position, speed):
        self.write('P' + position.to_string() + ',' + str(speed) + '\n')

    def power_off(self):
        self.write('0\n')

    def power_on(self):
        self.write('0\n')

if __name__ == "__main__":
    serial_port = input("Define serial port : ")
    robot = Braccio(serial_port=serial_port)
    