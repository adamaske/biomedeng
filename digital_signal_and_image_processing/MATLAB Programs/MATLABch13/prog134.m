% MATLAB Program 13.4 One-level wavelet transform compression
close all; clear all; clc
X=imread('cruise','JPEG'); 
Y=rgb2gray(X); % convert the image in grayscale
h0 =[0.054415842243144   0.312871590914520   0.675630736297712 ...
     0.585354683654425  -0.015829105256675  -0.284015542962009 ...
     0.000472484573805   0.128747426620538  -0.017369301001845 ...
     -0.044088253930837   0.013981027917411   0.008746094047413 ...
     -0.004870352993456  -0.000391740373377   0.000675449406451 ...
     -0.000117476784125];
M= length(h0);
h1(1:2:M-1) = h0(M:-2:2);h1(2:2:M) = -h0(M-1:-2:1);%Obtain QMF highpass filter
[m n]=size(Y);
%level-1 transform
[m n]=size(Y);
for i=1:m
    W1(i,:)=dwt(h0,double(Y(i,:)),1)';
end
for i=1:n
    W1(:,i)=dwt(h0,W1(:,i),1); % Wavelet coefficents at level-1
end
% fnished
%Quantization using 8-bit
wmax=double(max(max(abs(W1)))); %Scale factor
W1=round(double(W1)*2^7/wmax); %Get 8-bit data
W1=double(W1)*wmax/2^7;%Recover the wavelet
figure (1)
imshow(uint8(W1));xlabel('Wavelet coefficients');
%Quantization
  [m, n]=size(W1);
  WW=zeros(m,n);
  WW(1:m/2,1:n/2)=W1(1:m/2,1:n/2);
  W1=WW;
%decoding from level-1 usig W1

[m, n]=size(W1);
for i=1:n
    Yd1(:,i)=idwt(h0,double(W1(:,i)),1);
end
for i=1:m
    Yd1(i,:)=idwt(h0,double(Yd1(i,:)),1)';
end
% fnished
YY1=uint8(Yd1);
figure (2),imshow(Y);xlabel('Original image');
figure (3),imshow(YY1);xlabel('4:1 Compression');
