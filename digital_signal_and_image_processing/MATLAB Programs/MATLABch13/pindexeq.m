close all; clear all
%This program performs histogram equalization of the 8-indexed color image
% using steps described in Section 13.2.3
disp('Read the rgb image');
   XX=imread('trees','JPEG');                  % provided by the instructor
 disp('Eqlization in 8-bit indexd color');
[Xind, map]=rgb2ind(XX, 256);   % rgb to 8-bit index image conversion
YIQmap=rgb2ntsc(map);    % convert the RGB color map to the YIQ color map
Xg=ind2gray(Xind,map);               % grayscale image
EXg=histeq(Xg);           % grayscale hitogram equalization
[M N]=size(EXg);
Yeq=YIQmap(:,1);    %initialize the new Y channel.
for i=1:M           % find the equalized Y values in the color map
    for j=1:N
        Yeq(Xind(i,j)+1)=double(EXg(i,j))/255;
    end
end
SF=Yeq./max(YIQmap(:,1),eps);  % determine the scale factor vector
newmap= map.*(SF*ones(1,3));   % scale the original rgb color map
newmap = newmap ./ (max(max(newmap')',1)*ones(1,3)); % normalized to be (0 1)

imshow(Xind, map);
title('Original 8-bit indexed color image');
figure
imshow(Xind,newmap);
title('EQ in 8-bit indexed color');

