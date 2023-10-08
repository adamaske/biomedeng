import numpy as np
from kin_math import Rotation_Matrix, Translation_Matrix
from kin_math import Axis, Print_Vector_String
from kin_math import DH_Param, DH_Translation_Matrix

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
        
class Robot():
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
    def Set_Thetas(self, t0, t1, t2, t3, t4):
        
        self.m_t0 = t0
        self.m_t1 = t1
        self.m_t2 = t2
        self.m_t3 = t3
        self.m_t4 = t4
        self.m_links[0].m_theta = t0+180 
        self.m_links[1].m_theta = t1-90
        self.m_links[2].m_theta = t2-90
        self.m_links[3].m_theta = t3-90
        self.m_links[4].m_theta = t4#-90
        self.m_links[0].m_dh_param.m_theta = t0#
        self.m_links[1].m_dh_param.m_theta = t1#
        self.m_links[2].m_dh_param.m_theta = t2-90
        self.m_links[3].m_dh_param.m_theta = t3-90
        self.m_links[4].m_dh_param.m_theta = t4#-90
        return
    def Clear_Links(self):
        self.m_links = []
        
    def Create_Links(self):

        self.m_links.append( Link(Axis.Z, self.m_t0, np.array((0, 0, 7.15)),  DH_Param(self.m_t0, 90, 0, 7.15)))
        self.m_links.append( Link(Axis.Y, self.m_t1, np.array((0, 0, 12.5)),  DH_Param(self.m_t1, 0, 12.5, 0)))
        self.m_links.append( Link(Axis.Y, self.m_t2, np.array((0, 0, 12.5)),  DH_Param(self.m_t2, 0, 12.5, 0)))
        self.m_links.append( Link(Axis.Y, self.m_t3, np.array((0, 0, 12.5)) ,  DH_Param(self.m_t3, 0, 12.5+13.2, 0)))
        self.m_links.append( Link(Axis.Z, self.m_t4, np.array((0, 0, 13.2)),  DH_Param(0, 0, 0, 0)))
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
    
    def Pose(self, orientation_matrix, location_matrix):
        #self.Clear_Links()
        #self.Create_Links()
        
        #Get DH Translation Matrix
        dh_mat = self.Robot_DH_Matrix()
        #Location of DH Translation
        dh_fk_location = np.array((dh_mat[0][3], dh_mat[1][3], dh_mat[2][3]))
        Print_Vector_String("dh_fk_location", dh_fk_location)
       
        #Regular FK 
        fk_end_effector = self.End_Effector_Transformation_Matrix()

        fk_end_effector_location = np.array((fk_end_effector[0][3], fk_end_effector[1][3], fk_end_effector[2][3]))
        Print_Vector_String("fk_end_effector_location", fk_end_effector_location)
    
    def Solve_IK(self, transformation_matrix):
        
        return
    
    def Pose_Brain():
        
        print("ok")
        
    
if __name__ == "__main__":
    
   
    brain = Brain()
    
    robot = Robot()
    robot.Set_Brain(brain)
    
    target_brain_space = brain.m_target
    target_brain_space_matrix = Translation_Matrix(target_brain_space)
    #print("target_brain_space_matrix : ")
    #print(target_brain_space_matrix)
    
    brain_rotation = brain.Brain_Rotation_Matrix()
    #print("brain_rotation : ")
    #print(brain_rotation)
    
    brain_location_robot_space_matrix = Translation_Matrix(brain.m_global_location)
    
    k_target_robot_space = brain_rotation * target_brain_space_matrix 
    #print("k_target_robot_space : ")
    #print(k_target_robot_space)

    robot.Set_Thetas(t0=0, t1=0, t2=0, t3=0, t4=00)
    
    robot.Pose(0, k_target_robot_space)
    
    
