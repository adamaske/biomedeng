import numpy as np
from enum import Enum

class DH_Param():
    def __init__(self, theta, alpha, r, d) -> None:
        self.m_theta = theta
        self.m_alpha = alpha
        self.m_r = r
        self.m_d = d
        
        return
    
def DH_Translation_Matrix(dh_param):
    mat = np.identity(4)
    theta  = np.deg2rad(dh_param.m_theta)
    alpha= np.deg2rad(dh_param.m_alpha)
    r = dh_param.m_r
    d = dh_param.m_d
    
    ca = np.cos(alpha)
    sa = np.sin(alpha)
    
    ct = np.cos(theta)
    st = np.sin(theta)

    mat[0][0] = ct
    mat[0][1] = -st*ca
    mat[0][2] = st * sa
    mat[0][3] = r*ct
    
    mat[1][0] = st
    mat[1][1] = ct*ca
    mat[1][2] = -ct*sa
    mat[1][3] = r*st
    
    mat[2][0] = 0
    mat[2][1] = sa
    mat[2][2] = ca
    mat[2][3] = d
    
    mat[3][0] = 0
    mat[3][1] = 0
    mat[3][2] = 0
    mat[3][3] = 1
	
    return mat

class Axis(Enum):
    X = 0
    Y = 1
    Z = 2
    I = 3

def Rotation_Matrix(axis, theta):
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

def Translation_Matrix(vec):
    
    matrix = np.identity(4)
    matrix[0][3] = vec[0]
    matrix[1][3] = vec[1]
    matrix[2][3] = vec[2]
    
    return matrix

def Print_Vector_String(name, vector):
    print(f"{name} :")
    msg = f"x: {vector[0]:.1f}, y: {vector[1]:.1f}, z: {vector[2]:.1f}"
    print(msg)
    return msg
    