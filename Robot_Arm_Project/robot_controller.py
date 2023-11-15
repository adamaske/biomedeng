import numpy as np
from kin_math import Rotation_Matrix, Translation_Matrix
from kin_math import Axis, Print_Vector_String
from kin_math import DH_Param, DH_Translation_Matrix

from mdh.kinematic_chain import KinematicChain
from mdh import UnReachable

from pybotics.robot import Robot

import numpy.typing as npt

import sys
import serial
import serial.tools.list_ports

from serial import Serial
from serial import SerialException

from threading import Thread

import time

from pythonosc.osc_server import BlockingOSCUDPServer
from pythonosc.dispatcher import Dispatcher

d0 = 7.15
d1 = 12.5
d2 = 12.5
d3 = 6.0
d4 = 13.2

msg_queue = []

class Brain():
    def __init__(self):
    
        self.m_global_location  = np.array((40, 0, 20))
        self.m_rotation_axis = Axis.Y
        self.m_theta = -90
        self.m_target= np.array((10, 0, 0)) #(X=-2.958097,Y=4.203199,Z=2.500000)
        self.m_entry= np.array((20, 0, 0))#(X=-5.311189,Y=8.007011,Z=5.705144)
        
        self.m_x= np.array((-10, 7, 8))
        
      
    def Brain_Rotation_Matrix(self):
        matrix = Rotation_Matrix(self.m_rotation_axis, self.m_theta)
        return matrix
    def Brain_Global_Location_Matrix(self):
        return Translation_Matrix(self.m_global_location)
        
    def Info(self):
        print(f"Brain Position : {self.m_pos}")

class Link():
    def __init__(self, rotation_axis, theta, translation_vector, dh_param):
        self.m_axis = rotation_axis
        self.m_tranlsation = translation_vector
        self.m_theta = theta
        self.m_dh_param = dh_param
        return
    
    def Link_Rotation_Matrix(self):
        return Rotation_Matrix(self.m_axis, self.m_theta)
    
    def Link_Translation_Matrix(self):
        return Translation_Matrix(self.m_tranlsation)

    def Link_Transformation_Matrix(self):
        rot = self.Link_Rotation_Matrix()
        vec = self.Link_Translation_Matrix()
        
        t = np.matmul(rot, vec)
        return t
        
    def Link_DH_Param(self):
        return self.m_dh_param
        
class Robot_Custom():
    def __init__(self, arduino):
        self.arduino = arduino
        self.m_global_location  = np.array((40, 0, 20))
        self.m_brain = 0
        
        self.m_links = []
        
        self.m_t0 = 0
        self.m_t1 = 0
        self.m_t2 = 0
        self.m_t3 = 0
        self.m_t4 = 0
        
        self.Create_Links()
        return
    
    def Set_Theta_By_Index(self, val, index):
        if index == 0:
            self.m_t0 = val
        elif index == 1:
            self.m_t1 = val
        elif index == 2:
            self.m_t2 = val
        elif index == 3:
            self.m_t3 = val
        elif index == 4:
            self.m_t4 = val
        else:
            print("Index not found!")
            return
        print(f"Set t{index} to {val}")
        
    def Enter_Custom_Thetas(self, ):
        
        t0 = int(input("Enter t0 : "))
        t1 = int(input("Enter t1 : "))
        t2 = int(input("Enter t2 : "))
        t3 = int(input("Enter t3 : "))
        t4 = int(input("Enter t4 : "))
        
        self.Set_Thetas(t0, t1, t2, t3, t4)
        target_loc = np.matmul( Translation_Matrix(np.array((41,-3,7.15))) , Rotation_Matrix(Axis.I, 90) )
        self.Pose(0, target_loc)
           
    def Set_Thetas(self, t0, t1, t2, t3, t4):
        
        self.m_t0 = t0
        self.m_t1 = t1
        self.m_t2 = t2
        self.m_t3 = t3
        self.m_t4 = t4
        self.m_links[0].m_theta = t0
        self.m_links[1].m_theta = t1
        self.m_links[3].m_theta = t3
        self.m_links[2].m_theta = t2
        self.m_links[4].m_theta = t4#-90
        self.m_links[0].m_dh_param.m_theta = t0#
        self.m_links[1].m_dh_param.m_theta = t1#
        self.m_links[2].m_dh_param.m_theta = t2-90
        self.m_links[3].m_dh_param.m_theta = t3-90
        self.m_links[4].m_dh_param.m_theta = t4#-90
        return
            
    def Thetas_ToString(self):
        msg = str(self.m_t0) + ", " + str(self.m_t1) + ", " + str(self.m_t2) + ", " + str(self.m_t3) + ", " + str(self.m_t4) + ", "
        return msg

    def Clear_Links(self):
        self.m_links = []
        
    def Create_Links(self):

        self.m_links.append( Link(Axis.Z, self.m_t0, np.array((0, 0, d0)),  DH_Param(self.m_t0, 90, 0, d0)))
        self.m_links.append( Link(Axis.Y, self.m_t1, np.array((0, 0, d1)),  DH_Param(self.m_t1, 0, d1, 0)))
        self.m_links.append( Link(Axis.Y, self.m_t2, np.array((0, 0, d2)),  DH_Param(self.m_t2, 0, d2, 0)))
        self.m_links.append( Link(Axis.Y, self.m_t3, np.array((0, 0, d3 + d4)) ,  DH_Param(self.m_t3, 0, d3 + d4, 0)))
        self.m_links.append( Link(Axis.Z, self.m_t4, np.array((0, 0, 0)),  DH_Param(0, 0, 0, 0)))
        return 
    
    def Robot_DH_Matrix(self):
        dh_mat = np.identity(4)
        
        for link in range(len(self.m_links)):
            link_dh_param = self.m_links[link].Link_DH_Param()
            link_dh_mat = DH_Translation_Matrix(link_dh_param)
            dh_mat = np.matmul(dh_mat, link_dh_mat)

        return dh_mat
    
    def End_Effector_Transformation_Matrix(self):
        mat = np.identity(4)
        
        for link in self.m_links:
            mat = np.matmul( mat, link.Link_Transformation_Matrix())
            
        return mat
     
    def Set_Brain(self, brain):
        self.m_brain = brain
    
    def Pose(self):
        push_msg("Posing Robot started.")
        
       
        #Get DH Translation Matrix
        dh_mat = self.Robot_DH_Matrix()
        #Location of DH Translation
        dh_fk_location = np.array((dh_mat[0][3], dh_mat[1][3], dh_mat[2][3]))
        
        #Regular FK 
        #fk_end_effector = self.End_Effector_Transformation_Matrix()
        #fk_end_effector_location = np.array((fk_end_effector[0][3], fk_end_effector[1][3], fk_end_effector[2][3]))
        #Print_Vector_String("fk_end_effector_location", fk_end_effector_location)
        
        push_msg(f"Thetas : {self.m_t0}, {self.m_t1}, {self.m_t2}, {self.m_t3}, {self.m_t4}")
       
        #BRain
        brain_rot_mat = self.m_brain.Brain_Rotation_Matrix()

        brain_location_mat = Translation_Matrix(self.m_brain.m_global_location)
        brain_location = np.array((brain_location_mat[0][3], brain_location_mat[1][3], brain_location_mat[2][3])) 
        brain_loc = self.m_brain.m_global_location
        #Target
        target_brain_space = self.m_brain.m_target
        target_brain_space_mat = Translation_Matrix(target_brain_space)
        
        target_location_mat = np.matmul(brain_rot_mat, target_brain_space_mat)
        target_location = np.array((target_location_mat[0][3], target_location_mat[1][3], target_location_mat[2][3])) 
        target_loc = target_location + brain_loc
        target_error = target_loc - dh_fk_location
        #Entry  
        entry_brain_space = self.m_brain.m_entry
        entry_brain_space_mat = Translation_Matrix(entry_brain_space)
        
        entry_location_mat = np.matmul(brain_rot_mat, entry_brain_space_mat)
        entry_location = np.array((entry_location_mat[0][3], entry_location_mat[1][3], entry_location_mat[2][3])) 
        entry_loc = entry_location + brain_loc
        entry_error = entry_loc - dh_fk_location
        
        #Find error
        push_msg(Print_Vector_String("target_location", target_loc))
        push_msg(Print_Vector_String("entry_location", entry_loc))
        push_msg(Print_Vector_String("dh_fk_location", dh_fk_location))
        push_msg(f"target_error : {target_error}")
        push_msg(f"entry_error : {entry_error}")
        
        self.arduino.Write(self.Thetas_ToString())
        
        push_msg("Posing Robot ended.")
        
       
        
    def Pose_Brain(self):
        
        print("Posed Brain")
    
    

class Arduino_Controller():
    def __init__(self) -> None:
        self.ports = []
        self.active_port = None
        self.fake = False
        
    def Load_Ports(self):
        ports = list(serial.tools.list_ports.comports())
        port_count = len(ports)
        if port_count == 0:
            print("No available COMports, fake Arduino Enabled!")
            self.fake = True
        else:
            self.fake = False
    
        self.ports = ports
    
    def Select_Port(self):    
        if self.fake:
            print("\nConncected to fake Arduino COMPORT")
            return

        print("\nnAvailable COM Ports : ")
        for i in range(len(self.ports)):
            print(f"{i}. {self.ports[i]}")
            
        chosen = int(input("Select Port Index : "))
        
        try:
            self.active_port = serial.Serial(port=self.ports[chosen].device, baudrate=9600, timeout=.1) 
        except serial.SerialException:
                print(f"Could not connect to {self.ports[chosen]}!")
                exit()
                pass
        print(f"Connected to : {self.ports[chosen]}")
            
    def Write(self, msg):
        if self.fake:
            print(f"\nSent fake : {msg}")
            return
        
        self.active_port.write(bytes(msg, 'utf-8'))

    def Read(self):
        if self.fake:
            print(f"\nread fake msg")
            return "fake_msg"
        
        data = self.active_port.readline()
        return data



def default_handler(address, *args):
    print(f"DEFAULT {address}: {args}")

server_running = True
server_msg_queue = []
server_robot = None
def run_server(robot, ip, port):
    server_robot = robot
    dispatcher = Dispatcher()
    dispatcher.map("/robotsim/pose", pose_robot_serv)
    dispatcher.set_default_handler(default_handler)
    
    server =  BlockingOSCUDPServer((ip, port), dispatcher)

    server.serve_forever()
    server_msg_queue.append("OSC Server started.")
    
    fs = 1
    while server_running:
        #do whatever
        
        #server_msg_queue.append("OSC Server ticked (1).")
        time.sleep(1)
        
    server.server_close()
    server_msg_queue.append("OSC Server closed.")
        
def pose_robot_serv(address, *args):
    server_msg_queue.append(f"Server : Pose Robot Command started.")
    server_msg_queue.append(f"Addresss : {address}, args : {args}")
    
    if len(args) < 5:
        server_msg_queue.append(f"Missing Robot Angles : Got {len(args)}, need 5!")
        server_msg_queue.append("Server : Error")
        return

    server_robot.Set_Thetas(args[0], args[1], args[2], args[3], args[4])
    
    target_loc = np.matmul( Translation_Matrix(np.array((41,-3,7.15))) , Rotation_Matrix(Axis.I, 90) )
    robot.Pose(0, target_loc)
    
    server_msg_queue.append("Server : Successfull Pose Robot Command")
        
def dump_server():
    print(f"\nServer Dump : {len(server_msg_queue)}.")
    count = 1
    for msg in server_msg_queue:
        print(f"{count} : {msg}")
        count += 1
    server_msg_queue.clear()
    print(f"Server : Dump Complete.")
    
def push_msg(msg):
    msg_queue.append(msg)
    
def dump_msgs():
    print(f"\nMessage Dump : {len(msg_queue)}.")
    count = 1
    for msg in msg_queue:
        print(f"{count} : {msg}")
        count += 1
    msg_queue.clear()


if __name__ == "__main__":
    
    print("\nWelcome to RADBI!\n")
    ac = Arduino_Controller()
    ac.Load_Ports()
    ac.Select_Port()
    
    brain = Brain()
 
    robot = Robot_Custom(ac)
    robot.Set_Brain(brain)

    robot.Set_Thetas(0,0,0,0,0)
    server_robot = robot
    server_thread = Thread(target=run_server, args=(robot, "127.0.0.1", 7800))
    server_thread.start()
    
    run = True
    while run: #MAIN LOOP
        if len(msg_queue) > 0:
            dump_msgs()
        if len(server_msg_queue) > 0:
            dump_server()
            
        print(f"\nWhat do you want to do? : ")
        
        print(f"1. Calibrate Gyro")
        print(f"2. Pose Robot as Simulation")
        print(f"3. Custom Robot Angles")
        
        x = int(input("\nChoose command index : "))
        if x == 1:
            ac.Write("calibrate")
        elif x == 2:
            robot.Pose()
            ac.Write(robot.Thetas_ToString())
        elif x == 3:
            robot.Enter_Custom_Thetas()
        else:
            break

        print(ac.Read())
    
    server_running = False
    closed = server_thread.join()
    
    print(f"\n\nClosed.")
    
