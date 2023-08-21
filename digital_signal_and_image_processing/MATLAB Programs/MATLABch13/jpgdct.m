close all; clear all; clc
% This test program is a part of simulation for Grayscale JPEG image
% compression in Section 13.7.2.
% image size: 240x320
X=imread('cruiseog','TIFF');              %note the image size= 240x320
Y=rgb2gray(X);                          %Y =grayscale image
size(Y)
Q=[ 16 11 10 16 24 40 51 61;            %quantization quality factor
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];
factor=1;
Q=factor*Q;
Order=[ 0 1 5 6 14 15 27 28;             %zig-zag path
        2 4 7 13 16 26 29 42;
        3 8 12 17 25 30 41 43;
        9 11 18 24 31 40 44 53;
        10 19 23 32 39 45 52 54;
        20 22 33 38 46 51 55 60;
        21 34 37 47 50 56 59 61;
        35 36 48 49 57 58 62 63];
count=0;      % number of image blocks; total number of blocks =30x40=1200
for i=1:30
    for j=1:40
        count=count+1;
        P(1:8,1:8,count)=Y((i-1)*8+1:i*8,(j-1)*8+1:j*8);
    end
end
for m=1:1200
    F(:,:,m)=round(dct2(P(:,:,m)));   % 2-D DCT transform
    FF(:,:,m)=round(F(:,:,m) ./Q);    % quantization of DCT coefficients
end
%Coding and lossless compression. (not included)
%decoding
for m=1:1200
    FC(:,:,m)=FF(:,:,m) .*Q;          % recover 2-D DCT coefficients
    PP(:,:,m)=round(idct2(FC(:,:,m)));  % recover the 8x8 image image
    err(:,:,m)=single(PP(:,:,m))-single(P(:,:,m));  % quantization vector
end
count=0;
for i=1:30
    for j=1:40
        count=count+1;
        YY((i-1)*8+1:i*8,(j-1)*8+1:j*8)=PP(1:8,1:8,count); % recover image
    end
end
YY=uint8(YY); % level adjustment
figure
subplot(1,2,1),imshow(Y);  % original image
title('Orignal image');
subplot(1,2,2),imshow(YY)  % JPEG image
title('JPEG compressed image');
