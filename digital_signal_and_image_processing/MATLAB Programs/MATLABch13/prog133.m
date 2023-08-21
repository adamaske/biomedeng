% MATLAB Program 13.3
close all; clear all;clc
disp('Convert the grayscale image to the pseudo-color image1');
  [X, map]=imread('clipim2','gif'); % read 8-bit index image, provided by the instructor
   Y=ind2gray(X,map);                   % 8-bit color image to the grayscale conversion
 % apply pseudo color functions using sinusoids
   C_r =304;                                      % cycle change  for the red channel
P_r=0;                                           % phase change for the red channel
C_b=804;                                      % cycle change  for the blue channel
P_b=60;                                         % phase change for the blue channel
C_g=304;                                      % cycle change  for the green channel
P_g=60;                                         % phase change for the green channel
   r=abs(sin(2*pi*[-P_r:255-P_r]/C_r));    
   g=abs(sin(2*pi*[-P_b:255-P_b]/C_b));
   b=abs(sin(2*pi*[-P_g:255-P_g]/C_g));
   figure, subplot(3,1,1);plot(r,'r');grid;ylabel('R value')
   subplot(3,1,2);plot(g,'g');grid;ylabel('G value');
   subplot(3,1,3);plot(b,'b');grid;ylabel('B value');
   figure, imshow(Y);
   map=[r;g;b;]';                      % construct color map
   figure, imshow(Y,map);      % display pseudo color image
