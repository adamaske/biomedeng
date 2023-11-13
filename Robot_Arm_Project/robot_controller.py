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

from pythonosc.osc_server import AsyncIOOSCUDPServer
from pythonosc.dispatcher import Dispatcher
import asyncio

import time
t0 = 0
t1 = 0
t2 = 0
t3 = 0
t4 = 0

d0 = 7.15
d1 = 12.5
d2 = 12.5
d3 = 6.0
d4 = 13.2

class Brain():
    def __init__(self):
    
        self.m_global_location  = np.array((40, 0, 20))
        self.m_rotation_axis = Axis.Y
        self.m_theta = 0
        
        self.m_target= np.array((-6, 3, 4))
        self.m_entry= np.array((-8, 5, 6))
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
    def __init__(self):
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
        self.m_links[2].m_dh_param.m_theta = t2
        self.m_links[3].m_dh_param.m_theta = t3
        self.m_links[4].m_dh_param.m_theta = t4#-90
        return
    def Clear_Links(self):
        self.m_links = []
        
    def Create_Links(self):

        self.m_links.append( Link(Axis.Z, self.m_t0, np.array((0, 0, d0)),  DH_Param(self.m_t0, 0, 0, d0)))
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
    def Pybotics_Model(self)-> npt.NDArray[np.float64]:
        return np.array(
            [
                [0, 0, 0, d0],
                [0, d1,  0, 0],
                [0, d2,  0, 0],
                [0, d3 + d4, 0, 0],
                [0, 0, 0, 0]
            ]
        )

    def Pose(self, orientation_matrix, location_matrix):
        
        target_location = np.array((location_matrix[0][3], location_matrix[1][3], location_matrix[2][3]))
        
        #Find angles for ik
        ik_thetas = self.Solve_IK(location_matrix)
        print(f"IK_Thetas : {ik_thetas}")
        #Set thetas
        self.Set_Thetas(ik_thetas[0]-180, ik_thetas[1]-90, ik_thetas[2]-90, ik_thetas[3]-90, ik_thetas[4])
        #self.Set_Thetas(0, 90,90,90,0)
    
        #Get DH Translation Matrix
        dh_mat = self.Robot_DH_Matrix()
        #Location of DH Translation
        dh_fk_location = np.array((dh_mat[0][3], dh_mat[1][3], dh_mat[2][3]))
        
        #Regular FK 
        #fk_end_effector = self.End_Effector_Transformation_Matrix()
        #fk_end_effector_location = np.array((fk_end_effector[0][3], fk_end_effector[1][3], fk_end_effector[2][3]))
        #Print_Vector_String("fk_end_effector_location", fk_end_effector_location)
        
        #Find error
        Print_Vector_String("target_location", target_location)
        Print_Vector_String("dh_fk_location", dh_fk_location)
        
        error = dh_fk_location - target_location
        print(error)
        
    def Solve_IK(self, translation):
        np.set_printoptions(suppress=True)

        ## modified DH parameters: alpha a theta d
        ## types: revolute=1, prismatic=2 (not implemented yet)
        
        np.set_printoptions(suppress=True)

        robot = Robot.from_parameters(self.Pybotics_Model())
        
        joints = np.deg2rad([0,0,0,0,0])
        dh_fk_mat = robot.fk(joints)
        
        print("dh_fk_mat : ")
        print(dh_fk_mat)
        
        fk_dh_location = np.array((translation[0][3], translation[1][3], translation[2][3]))
        print(f"fk_dh_location : {fk_dh_location}")
        
        solved_joints = robot.ik(translation)
        print(f"solved_joints : {solved_joints}")

        print("target_translation : ")
        print(translation)
        return np.rad2deg(solved_joints)
    
    def Pose_Brain():
        
        print("Posed Brain")
        
    def Thetas_ToString(self):
        msg = str(self.m_t0) + ", " + str(self.m_t1) + ", " + str(self.m_t2) + ", " + str(self.m_t3) + ", " + str(self.m_t4) + ", "
        return msg



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
            print("Conncected to fake Arduino COMPORT")
            return

        print("Available COM Ports : ")
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
            print(f"Sent fake : {msg}")
            return
        
        self.active_port.write(bytes(msg, 'utf-8'))

    def Read(self):
        if self.fake:
            print(f"read fake msg")
            return "fake_msg"
        
        data = self.active_port.readline()
        return data

class Server():
    def __init__(self):
        self.IP = "127.0.0.1"
        self.PORT = 7800
        
        self.server = None
        self.robot = None
        self.arduino = None
        self.transport = None
    async def run(self):
        dispatcher = Dispatcher()
        dispatcher.map("/robotsim/pose", self.pose_robot)
        
        self.server = AsyncIOOSCUDPServer((self.IP, self.PORT), dispatcher, asyncio.get_event_loop())
        self.server
        transport, protocol = await self.server.create_serve_endpoint()
        print(f"OSC Server started.")
        self.transport = transport
        await self.listen_loop(600)
        
        transport.close()
        print(f"OSC Server closed.")
        
    async def listen_loop(self, run_time):
        for i in range(run_time):
            #print(f"Loop {i}")
          
            await asyncio.sleep(1)
            
    def pose_robot(self, address, *args):
        print(f"Got Pose Robot Command : ")
        print(f"{address} : {args}")
        if len(args) < 5:
            print(f"Missing Robot Angles : Got {len(args)}, need 5!")
            return
        self.robot.Set_Thetas(args[0], args[1], args[2], args[3], args[4])
        self.arduino.Write(self.robot.Thetas_ToString())
    
     
    

class Command():
    def __init__(self, name, command):
        self.name = name
        self.command = command
        
if __name__ == "__main__":
    
    ac = Arduino_Controller()
    ac.Load_Ports()
    ac.Select_Port()
    
   
    brain = Brain()
    
    target_brain_space = brain.m_target
    target_brain_space_matrix = Translation_Matrix(target_brain_space)

    brain_rotation = brain.Brain_Rotation_Matrix()

    brain_location_robot_space_matrix = Translation_Matrix(brain.m_global_location)
    
    robot = Robot_Custom()
    robot.Set_Brain(brain)

    k_target_robot_space = brain_rotation * target_brain_space_matrix 

    #robot.Set_Thetas(t0=0, t1=90, t2=90, t3=90, t4=0)
    target_loc = np.matmul( Translation_Matrix(np.array((41,-3,7.15))) , Rotation_Matrix(Axis.I, 90) )
    robot.Pose(0, target_loc)
    
    robot.Set_Thetas(0, 45, 45, 45, 45)
    
    # send to Arduino
    server = Server()
    server.robot = robot #will crash without
    server.arduino = ac
    asyncio.run(server.run())
    
    #CREATE ARDUINO MESSAGE
    run = True
    while run:
        
        print(f"What do you want to do? : ")
        commands = []
        commands.append(Command("Calibrate Gyro", "calibrate"))
        commands.append(Command("Pose Robot as PyRobot", robot.Thetas_ToString()))
        commands.append(Command("Pose Robot as UE5", robot.Thetas_ToString()))
        index = 1
        for command in commands:
            
            print(f"{index}. {command.name}")
            index += 1
        
        x = int(input("Choose command index : "))
        if x < 0 or x > len(commands):
            print("Not recongnized, exiting!")
            server.transport.close()
            exit()
            break
        
        command = commands[x-1]
        print(f"Sending : {command.name}!")
        print(robot.Thetas_ToString())
        ac.Write(command.command)
        
        print(ac.Read())
        
    
