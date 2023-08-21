% MATLAB Program 11.6  
% this program is the polyphase implementation for interpolation Figure 11.18
%Up sampling filter  (see Chapter 7 for FIR filter design)
close all; clear all;clc
B =[ -0.00012783931504   0.00069976044649   0.00123831516738   0.00100277549136...
  -0.00025059018468  -0.00203448515158  -0.00300830295487  -0.00174101657599...
   0.00188598835011   0.00578414933758   0.00649330625041   0.00177982369523...
  -0.00670672686935  -0.01319379342716  -0.01116855281442   0.00123034314117...
   0.01775600060894   0.02614700427364   0.01594155162392  -0.01235169936557...
  -0.04334322148505  -0.05244745563466  -0.01951094855292   0.05718573279009...
   0.15568416401644   0.23851539047347   0.27083333333333   0.23851539047347...
   0.15568416401644   0.05718573279009  -0.01951094855292  -0.05244745563466...
  -0.04334322148505  -0.01235169936557   0.01594155162392   0.02614700427364...
   0.01775600060894   0.00123034314117  -0.01116855281442  -0.01319379342716...
  -0.00670672686935   0.00177982369523   0.00649330625041   0.00578414933758...
   0.00188598835011  -0.00174101657599  -0.00300830295487  -0.00203448515158...
  -0.00025059018468   0.00100277549136   0.00123831516738   0.00069976044649...
  -0.00012783931504];
% Generate 2048 samples with fs=8000 Hz
fs=8000;                                      % sampling rate 
N=2048;                                       % number of samples
L = 3;                                        % up sampling factor 
n=0:1:N-1;
x=5*sin(n*pi/4)+cos(5*n*pi/8);
% Interpolation using the polyphase method
p0=B(1:L:length(B));    %filter 0
p1=B(2:L:length(B));    %filter 1
p2=B(3:L:length(B));    %filter 2
w0=filter(p0,1,x);      % filtering 
w1=filter(p1,1,x);  %filtering 
w2=filter(p2,1,x); %filterinng 
y0=zeros(1,L*length(w0));
y0(1:L:L*length(w0))=w0;  % upsampled for channel 0 by L
y1=zeros(1,L*length(w1));
y1(1:L:L*length(w1))=w1;  % upsampled for channel 1 by L
y2=zeros(1,L*length(w2));
y2(1:L:L*length(w2))=w2;  % upsampled for channel 2 by L
y1=filter([0 1],1,y1); % delay one sample
y2=filter([0 0 1],1,y2); % delay two samples
y=y0+y1+y2;  %polyphase output
% the polyphase implementation ends
X=2*abs(fft(x,N))/N;X(1)=X(1)/2; %compute one-sided input amplitude spectrum
f=[0:1:N/2-1]*fs/N;  % map the frequency index to the frequency (Hz)
NL=length(x)*L;
Y=2*abs(fft(y,NL))/NL;Y(1)=Y(1)/2; %compute one-sided amplitude spectrum
fsL=[0:1:NL/2-1]*fs*L/NL; % map the frequency index to the frequency (Hz)
subplot(2,1,1);plot(f,X(1:1:N/2));grid; xlabel('Frequency (Hz)'); ylabel('Input spectrum');
subplot(2,1,2);plot(fsL,Y(1:1:NL/2));grid; xlabel('Frequency (Hz)');ylabel('Upsampled spectrum');
