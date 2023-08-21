%MATLAB Program 10.16
%Waveform coding using DCT and MDCT for a block size of 16 samples
%  Main program
close all; clear all
load we.dat% provided by the instructor
load speech.dat
we=speech;
% create scale factors 
N=16; %blocksize
scalef4bits=sqrt(2*N)*[1 2 4 8 16 32 64 128 256 512 1024 ...
                  2048 4096 8192 16384 32768];
scalef3bits=sqrt(2*N)*[256 512 1024 2048 4096 8192 16384 32768];
scalef2bits=sqrt(2*N)*[4096 8192 16384 32768];
scalef1bit=sqrt(2*N)*[16384 32768];
scalef=scalef3bits;
nbits =3;
% ensure the block size to be 16 samples.
x=[we zeros(1,16-mod(length(we),16))];
Nblock=length(x)/16;
DCT_code=[]; scale_code=[];
% encoder
  for i=1:Nblock
    xblock_DCT=dct(x((i-1)*16+1:i*16));
    diff=(scalef-(max(abs(xblock_DCT))));
   iscale(i)=min(find(diff==min(diff(find(diff>=0)))));%find a scale factor
    %iscale(i)=min(find(diff<=min(diff)));    %find a scale factor
    xblock_DCT=xblock_DCT/scalef(iscale(i));    % scale the input vector
     for j=1:16
      [DCT_coeff(j) pp]=biquant(nbits,-1,1,xblock_DCT(j));
     end
     DCT_code=[DCT_code DCT_coeff ];
 end
%decoder
Nblock=length(DCT_code)/16;
xx=[];
for i=1:Nblock
      DCT_coefR=DCT_code((i-1)*16+1:i*16);
    for j=1:16
        xrblock_DCT(j)=biqtdec(nbits,-1,1,DCT_coefR(j));
    end
        xrblock=idct(xrblock_DCT.*scalef(iscale(i)));
    xx=[xx xrblock];
end
% Transform coding using MDCT
xm=[zeros(1,8) we zeros(1,8-mod(length(we),8)), zeros(1,8)];
Nsubblock=length(x)/8;
MDCT_code=[]; 
% encoder
  for i=1:Nsubblock
    xsubblock_DCT=wmdct(xm((i-1)*8+1:(i+1)*8));
    diff=(scalef-max(abs(xsubblock_DCT)));
   iscale(i)=min(find(diff==min(diff(find(diff>=0)))));%find a scale factor
    %iscale(i)=min(find(diff<=min(diff)));    %find a scale factor
    xsubblock_DCT=xsubblock_DCT/scalef(iscale(i));    % scale the input vector
    for j=1:8
     [MDCT_coeff(j) pp]=biquant(nbits,-1,1,xsubblock_DCT(j));
    end
     MDCT_code=[MDCT_code MDCT_coeff];
 end
%decoder
% recover thr first subblock
Nsubblock=length(MDCT_code)/8;
xxm=[];
MDCT_coeffR=MDCT_code(1:8);
for j=1:8
        xmrblock_DCT(j)=biqtdec(nbits,-1,1,MDCT_coeffR(j));
end
xmrblock=wimdct(xmrblock_DCT*scalef(iscale(1)));
xxr_pre=xmrblock(9:16); % recovered first block for overlap and add
for i=2:Nsubblock
    MDCT_coeffR=MDCT_code((i-1)*8+1:i*8);
    for j=1:8
        xmrblock_DCT(j)=biqtdec(nbits,-1,1,MDCT_coeffR(j));
   end
        xmrblock=wimdct(xmrblock_DCT*scalef(iscale(i)));
    xxr_cur=xxr_pre+xmrblock(1:8);  % overlap and add
    xxm=[xxm xxr_cur];
    xxr_pre=xmrblock(9:16);                % set for the next overlap 
end
 
subplot(3,1,1);plot(x);grid; axis([0 length(x) -10000 10000])
ylabel('Original signal');
subplot(3,1,2);plot(xx);grid;axis([0 length(xx) -10000 10000]);
ylabel('DCT coding')
subplot(3,1,3);plot(xxm);grid;axis([0 length(xxm) -10000 10000]);
ylabel('W-MDCT coding');
xlabel('Sample number');
