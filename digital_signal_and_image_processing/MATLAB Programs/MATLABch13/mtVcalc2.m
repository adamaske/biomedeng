%MATLAB progran for Example of motion vector estimation in Section 13.10
clc; close all; clear all
% create an 80x80 image
for i=1:80
    for j=1:80
       v1(i,j)=round(255*sin(2*pi*i/160)*sin(2*pi*j/160));
    end
end
v2=100*zeros(80,80);
v2(5:80,7:80)=v1(1:76,1:74); % displace the image down 4 and right by 6 pixels to get the target image
subplot(2,2,1);imshow(uint8(v1));title('Reference image');
subplot(2,2,3);imshow(uint8(v2));title('Target image');
cnti=1;cntj=1;
vv1=100*zeros(96,96); %padd image boundary with zeros
vv1(9:88,9:88)=v1;
for i=1:5 % motion vector search in the range of 5 16x16  blocks both in horizaontal and vertical
    for j=1:5
         [u,v, min_MAD]=motionV(v2((i-1)*16+1:i*16,(j-1)*16+1:j*16),...
         vv1((i-1)*16+1:(i+1)*16,(j-1)*16+1:(j+1)*16));
         mvV(cnti)=u;
         mvH(cntj)=v;
         cnti=cnti+1;
         cntj=cntj+1;
         min_MAD
    end
end
mvV-9
mvH-9
%recover from the motion vectors
cnt=1;
for i=1:5
    for j=1:5
     vv2((i-1)*16+1:16*i,(j-1)*16+1:j*16)= ...
                vv1((i-1)*16+mvV(cnt):16*i+mvV(cnt)-1,...
                   (j-1)*16+mvH(cnt):16*j+mvH(cnt)-1);
    cnt=cnt+1;
    end
end
subplot(2,2,4);imshow(uint8(vv2));title('Recoverd image from MVs');
ee=v1-v2;
subplot(2,2,2);imshow(im2uint8(mat2gray(ee)));title('Reference image - target image')
