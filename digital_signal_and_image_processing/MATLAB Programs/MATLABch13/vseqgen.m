%MATLAB Program for mixing two images to create a video sequence
% Section 13.8
close all; clear all;clc;
%If X is the true color image with R, G, B, then
X=imread('grandc','JPEG'); 
Y=rgb2gray(X);
X1=imread('cruise','JPEG'); 
Y1=rgb2gray(X1);
subplot(1,2,1);imshow(X);
subplot(1,2,2);imshow(X1);
pause;
close all;
image1=X;
image2=X1;
disp('Creating the color video sequence=>');
disp('Hit "enter key" to capture=>');
pause;
%In MATLAB to display the video sequence, what actually happens is that a set of images are displayed sequentially at a frame rate specified by the user. Therefore, in order to do this lab, we must first create a set of images to display as video. For this video sequence, we will read in two different images (i.e. image1 and image2) using commands specified above. image1 will be your first frame and image2 will be your last frame (there will be twenty frames in all). Then, for the 18 frames in between the first (image1) and last (image2) frame you will create an image that 'fades' from image1 to image2. To do this, you will take a linear combination of image1 and image2 to form them in between images. For example, for the first frame after image2 you can take 
%frame1=.95*image1+.05*image2;
%frame2=.9*image1+.1*image2; 
%True color video sequence:
   M=moviein(10); 
   frame=image1;
   imshow(frame);
   M(:,1)=getframe;
   frame=.9*image1+.1*image2;
   imshow(frame);
   M(:,2)=getframe;
   frame=.8*image1+.2*image2; 
   imshow(frame);
   M(:,3)=getframe;
   frame=.7*image1+.3*image2; 
   imshow(frame);
   M(:,4)=getframe;
   frame=.6*image1+.4*image2; 
   imshow(frame);
   M(:,5)=getframe; 
   frame=.5*image1+.5*image2; 
   imshow(frame);
   M(:,6)=getframe;  
   frame=.4*image1+.6*image2; 
   imshow(frame);
   M(:,7)=getframe;   
   frame=.3*image1+.7*image2; 
   imshow(frame);
   M(:,8)=getframe;
   frame=.2*image1+.8*image2; 
   imshow(frame);
   M(:,9)=getframe;  
   frame=.1*image1+.9*image2; 
   imshow(frame);
   M(:,10)=getframe;  
disp('hit "enter key" to run video sequence=>');
pause;
   movie(M,4,2);

subplot(1,2,1);imshow(Y);
subplot(1,2,2);imshow(Y1);
pause;
close all
disp('Creating the grascale video sequence=>');
disp('Hit "enter key" to capture=>');
pause;
%Grayscale video sequence: 
   M=moviein(10); 
   frame=image1;
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,1)=getframe;
   frame=.9*image1+.1*image2;
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,2)=getframe;
   frame=.8*image1+.2*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,3)=getframe;
   M(:,3);
   frame=.7*image1+.3*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,4)=getframe;
   frame=.6*image1+.4*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,5)=getframe;
   frame=.5*image1+.5*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,6)=getframe;
   frame=.4*image1+.6*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,7)=getframe;
   frame=.3*image1+.7*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,8)=getframe;
   frame=.2*image1+.8*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,9)=getframe;
   frame=.1*image1+.9*image2; 
   frame=rgb2gray(frame);
   imshow(frame);
   M(:,10)=getframe;
disp('hit "enter key" to run video sequence=>');
pause
   movie(M,4,2);
  

















