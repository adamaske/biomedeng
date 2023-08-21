% MATLAB Program 13.1
close all; clear all;
disp('Read the rgb image');
   XX=imread('trees','JPEG');                  % provided by the instructor
   figure, imshow(XX);                            %title('24-bit color');   
disp('the grayscale image and histogram');
   Y=rgb2gray(XX);                                %rgb to grayscale conversion
   figure, subplot(1,2,1);imshow(Y);
   title('original');subplot(1,2,2);imhist(Y, 256);
 
disp('Equalization in grayscale domain');
Y=histeq(Y);
figure, subplot(1,2,1); imshow(Y);
title('EQ in grayscale-domain'); subplot(1,2,2); imhist(Y, 256);
 
disp('Equalization of Y channel for RGB color image');
figure
subplot(1,2,1); imshow(XX);
title('Original RGB color');
subplot(1,2,2); imhist(rgb2gray(XX),256); 
 
Z1=rgb2ntsc(XX);                      % conversion from RGB to YIQ
Z1(:,:,1)=histeq(Z1(:,:,1));          %equalizing Y channel;
ZZ=ntsc2rgb(Z1);                       %convertion from YIQ to RGB
 
figure
subplot(1,2,1); imshow(ZZ);
title('EQ for Y channel for RGB color image');
subplot(1,2,2); imhist(im2uint8(rgb2gray(ZZ)),256);
 
ZZZ=XX;
ZZZ(:,:,1)=histeq(ZZZ(:,:,1)); %equalizing R channel
ZZZ(:,:,2)=histeq(ZZZ(:,:,2)); %equalizing G channel
ZZZ(:,:,3)=histeq(ZZZ(:,:,3)); %equalizing B channel
figure
subplot(1,2,1); imshow(ZZZ);
title('EQ for RGB channels');
subplot(1,2,2); imhist(im2uint8(rgb2gray(ZZZ)),256);
 
disp('Eqlization in 8-bit indexd color');
[Xind, map]=rgb2ind(XX, 256);   % rgb to 8-bit index image conversion
newmap=histeq(Xind,map);
figure
subplot(1,2,1); imshow(Xind,newmap);
title('EQ in 8-bit indexed color');
subplot(1,2,2); imhist(ind2gray(Xind,newmap),256);
