import numpy as np

from enum import Enum
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

class Axis(Enum):
    X = 0
    Y = 1
    Z = 2
    I = 3

def RotationMatrix(axis, theta):
    matrix = np.identity(4)
    theta_rad = np.deg2rad(theta)
    ct = np.cos(theta_rad)
    st = np.sin(theta_rad)
    
    if axis == Axis.X:
        matrix[1][1] = ct
        matrix[2][1] = st
        
        matrix[1][2] = -st
        matrix[2][2] = ct
        
    elif axis == Axis.Y:
        matrix[0][0] = ct
        matrix[0][2] = st
        
        matrix[2][0] = -st
        matrix[2][2] = ct
    elif axis == Axis.Z:
        matrix[0][0] = ct
        matrix[1][0] = st
        
        matrix[0][1] = -st
        matrix[1][1] = ct
    elif axis == Axis.I:
        return matrix
    
    return matrix 

def TranslationMatrix(x, y, z):
    
    matrix = np.identity(4)
    matrix[0][3] = x
    matrix[1][3] = y
    matrix[2][3] = z
    
    return matrix

class Brain():
    def __init__(self):
        self.m_pos = np.array((40, 0, 20))
        self.m_target= np.array((-6, 3, 4))
        self.m_entry= np.array((-8, 5, 6))
        self.m_x= np.array((-10, 7, 8))
        
        self.m_rotation_axis = Axis.Y
        self.m_theta = 0
    def Brain_Rotation_Matrix(self):
        matrix = RotationMatrix(self.m_rotation_axis, self.m_theta)
        return matrix
    def Info(self):
        print(f"Brain Position : {self.m_pos}")
    
class Joint():
    def __init__(self, axis):
        self.m_axis = axis   
class Robot():
    def __init__(self):
        self.m_pos = np.array((0,0,0))
        
        self.m_joints = []
        self.m_joints.append(Joint(Axis.Z))
        self.m_joints.append(Joint(Axis.Y))
        self.m_joints.append(Joint(Axis.Y))
        self.m_joints.append(Joint(Axis.Y))
        self.m_joints.append(Joint(Axis.Z))
        
        return

    def Pose(self, orientation, location):
        
        _t0 = 0
        _t1 = 0
        _t2 = 0
        _t3 = 0
        _t4 = 0
        _t0 = 0
        T1 = RotationMatrix(Axis.Z, _t0)
        print(orientation)
        print(location)
        
        
        
    
    
    
if __name__ == "__main__":
       
    brain = Brain()
    robot = Robot()
    target_brain_space = TranslationMatrix(0, 0, 1)
    print(target_brain_space)
    target_robot_space = brain.Brain_Rotation_Matrix() * target_brain_space
    
    print(target_robot_space)
    
    brain_target_robot_space = np.array((0,1,1))

    #robot.Pose(0, brain_target_robot_space)
    
