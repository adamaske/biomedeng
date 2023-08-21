close all; clear all; clc
% This test program is a part of simulation for color JPEG image
% compression in Section 13.7.3
% image size: 240x320x3
X=imread('grandorg','TIFF'); 
X=single(X);  % single precision
Y=rgb2gray(X);  % Y -channel
Q=[ 16 11 10 16 24 40 51 61;   % quality factor for Y components
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];
QC=[17 18 24 47 99 99 99 99;   % quality factor of I or Q components
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99];
factorY=1;
Q=factorY*Q;
factorC=1;
QC=factorC*QC;
Order=[ 0 1 5 6 14 15 27 28;    %zig-zag path
        2 4 7 13 16 26 29 42;
        3 8 12 17 25 30 41 43;
        9 11 18 24 31 40 44 53;
        10 19 23 32 39 45 52 54;
        20 22 33 38 46 51 55 60;
        21 34 37 47 50 56 59 61;
        35 36 48 49 57 58 62 63];
%transform to YIQ
    YIQ(:,:,1)=0.299*X(:,:,1)+0.587*X(:,:,2)+0.114*X(:,:,3);
    YIQ(:,:,2)=0.596*X(:,:,1)-0.274*X(:,:,2)-0.322*X(:,:,3);
    YIQ(:,:,3)=0.212*X(:,:,1)-0.523*X(:,:,2)+0.311*X(:,:,3);
count=0;    % number of 8x8x3 image blocks for Y components
for i=1:30
    for j=1:40
        count=count+1;
        P(1:8,1:8,count)=YIQ((i-1)*8+1:i*8,(j-1)*8+1:j*8,1);
    end
end
for m=1:1200   %  operating for 30x40x3 blocks =1200 blocks 
    F(:,:,m)=round(dct2(P(:,:,m))); % DCT transform
    FF(:,:,m)=round(F(:,:,m) ./Q);  % DCT coefficient quantization
end
count=0;  % operate for I componenets
for i=1:30
    for j=1:40
        count=count+1;
        PI(1:8,1:8,count)=YIQ((i-1)*8+1:i*8,(j-1)*8+1:j*8,2);
    end
end
for m=1:1200
    F(:,:,m)=round(dct2(PI(:,:,m)));  %DCT transform
    FFI(:,:,m)=round(F(:,:,m)./QC);   % DCT coefficient quantization
end

count=0;        % operating for Q component
for i=1:30
    for j=1:40
        count=count+1;
        PQ(1:8,1:8,count)=YIQ((i-1)*8+1:i*8,(j-1)*8+1:j*8,3);
    end
end
for m=1:1200
    F(:,:,m)=round(dct2(PQ(:,:,m)));    %DCT transform
    FFQ(:,:,m)=round(F(:,:,m)./QC);     % DCT coefficient quantzation
end

% Further coding and lossless compression (not included)
%decoding
for m=1:1200
    FC(:,:,m)=FF(:,:,m) .*Q;            % recoveribg DCT coefficients
    PP(:,:,m)=round(idct2(FC(:,:,m)));  % recovering 8x8 image block for Y component
end
count=0;
for i=1:30     
    for j=1:40
        count=count+1;
        YY((i-1)*8+1:i*8,(j-1)*8+1:j*8,1)=PP(1:8,1:8,count); % Y components
    end
end

for m=1:1200    %recoverinbg the I component
    FIC(:,:,m)=FFI(:,:,m).*QC;
    PPI(:,:,m)=round(idct2(FIC(:,:,m)));
end
count=0;
for i=1:30
    for j=1:40
        count=count+1;
        YY((i-1)*8+1:i*8,(j-1)*8+1:j*8,2)=PPI(1:8,1:8,count);
    end
end

for m=1:1200  %recoverinbg the Q component
    FQC(:,:,m)=FFQ(:,:,m).*QC;
    PPQ(:,:,m)=round(idct2(FQC(:,:,m)));
end
count=0;
for i=1:30
    for j=1:40
        count=count+1;
        YY((i-1)*8+1:i*8,(j-1)*8+1:j*8,3)=PPQ(1:8,1:8,count);
    end
end

%transform to RGB
    RGB(:,:,1)=1.0*YY(:,:,1)+0.956*YY(:,:,2)+0.621*YY(:,:,3);
    RGB(:,:,2)=1.0*YY(:,:,1)-0.272*YY(:,:,2)-0.647*YY(:,:,3);
    RGB(:,:,3)=1.0*YY(:,:,1)-1.106*YY(:,:,2)+1.703*YY(:,:,3);

X=uint8(X);  %level adjustment
RGB=uint8(RGB);%level adjustment
subplot(1,2,1),imshow(X);title('Original image');
subplot(1,2,2), imshow(RGB); title('JPEG image');
