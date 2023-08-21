% MATLAB Program 13.2
close all;clear all; clc;
X=imread('cruise','jpeg');               % provided by the instructor
Y=rgb2gray(X);                              % convert the rgb image to the grayscale image
I=im2double(Y);                            % get the intensity image
image1_g=imnoise(I,'gaussian');    % add random noise to the intensity image
ng=mat2gray(image1_g);               % adjust the range
ng=im2uint8(ng);                           % 8-bit corrupted image
 
%Linear Filtering 
K_size= 5;                                             % Kernel size = 5x5
sigma =0.8;   % sigma = 0.8, the bigger the smoother the processed image
h=fspecial('gaussian',K_size,sigma);     % determine Gaussian filter coefficnets
%This command will construct a gaussian filter 
%of size 5x5 with a mainlobe width of 0.8. 
image1_out=filter2(h,image1_g);          % perform filetring
image1_out=mat2gray(image1_out);     % adjust the range
image1_out=im2uint8(image1_out);      % get the 8-bit image
subplot(1,2,1); imshow(ng),title('Noisy image');
subplot(1,2,2); imshow(image1_out);
title('5x5 Gaussian kernel');
 
%Median Filtering 
image1_s=imnoise(I,'salt & pepper');     % add “salt and pepper” noise to image
mn=mat2gray(image1_s);                      % adjust range
mn=im2uint8(mn);                                 % get the 8-bit image
 
K_size=3;                                                % kernel size
image1_m=medfilt2(image1_s,[K_size, K_size]);  % perform median filtering
image1_m=mat2gray(image1_m);          % adjust range
image1_m=im2uint8(image1_m);           % get the 8-bit image
figure, subplot(1,2,1);imshow(mn)
title('Median noisy');
subplot(1,2,2);imshow(image1_m);
title('3x3 medina kernel');
 
%Laplacian of Gaussian filtering 
K_size =5;                                    % kernel size=5
sigma =0.9;       % sigma parameter=0.9 
h=fspecial('log',K_size,sigma);       % the Laplacian of Gaissain filter
image1_out=filter2(h,I);                   % perform filtering
image1_out=mat2gray(image1_out);         % adjust range
image1_out=im2uint8(image1_out);          % get the 8-bit image
figure,subplot(1,2,1); imshow(Y)
title('Original');
subplot(1,2,2); imshow(image1_out);
title('Laplacian of Gaussian filter 5x5 kernel');
 
