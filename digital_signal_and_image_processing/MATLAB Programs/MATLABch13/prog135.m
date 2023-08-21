% MATLAB Program 13.5 Two-level wavelet compression
close all; clear all; clc
X=imread('cruise','JPEG'); 
%X=imread('cruiseorg','TIFF'); 
Y=rgb2gray(X);
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
%level-2 transform
Y1=W1(1:m/2,1:n/2); %Obtain LL subband
[m n]=size(Y1);
for i=1:m
    W2(i,:)=dwt(h0,Y1(i,:),1)';
end
for i=1:n
    W2(:,i)=dwt(h0,W2(:,i),1);
end
% fnished
W22=W1;
W22(1:m,1:n)=W2; % wavelet coefficients at level-2 transform
wmax=max(max(abs(W22)));
% 8-bit Quantization 
W22=round(W22*2^7/wmax);
W22=double(W22)*wmax/2^7;
figure(1), imshow(uint8(W22));xlabel('Wavelet coefficients');
 [m, n]=size(W22);
 WW=zeros(m,n);
 WW(1:m/4,1:n/4)=W22(1:m/4,1:n/4); 
 W22=WW;%Discard HL2,LH2, HH2, HL1, LH1, HH1 subbands
 % decoding from Level-2 transform
[m,n]=size(W22);
Wd2=W22(1:m/2,1:n/2);
%level-2
[m n]=size(Wd2);
for i=1:n
    Wd1(:,i)=idwt(h0,double(Wd2(:,i)),1);
end
for i=1:m
    Wd1(i,:)=idwt(h0,double(Wd1(i,:))',1);
end
%level-1
[m, n]=size(W22);Yd11=W22;
Yd11(1:m/2,1:n/2)=Wd1;
for i=1:n
    Yd(:,i)=idwt(h0,Yd11(:,i),1);
end
for i=1:m
    Yd(i,:)=idwt(h0,double(Yd(i,:)),1)';
end
% fnished
figure (2),imshow(Y);xlabel('Original image');
 Y11=uint8(Yd);
figure (3),imshow(Y11);xlabel('16:1 Compression');
