%MATLAB Program 11.1
close all; clear all;
% down sampling filter  ( see Chapter 7  for FIR filter design)
B =[0.00074961181416   0.00247663033476   0.00146938649416  -0.00440446121505 ...
  -0.00910635730662   0.00000000000000   0.02035676831506   0.02233710562885...
  -0.01712963672810  -0.06376620649567  -0.03590670035210   0.10660980550088...
  0.29014909103794   0.37500000000000   0.29014909103794   0.10660980550088...
  -0.03590670035210  -0.06376620649567  -0.01712963672810   0.02233710562885...
  0.02035676831506   0.00000000000000  -0.00910635730662  -0.00440446121505...
  0.00146938649416   0.00247663033476   0.00074961181416];
% generate 2048 samples
fs=8000;                                           % sampling rate
N=2048;                                           % number of samples 
M=2;                                                 % down sample factor
n=0:1:N-1;
x=5*sin(n*pi/4)+cos(5*n*pi/8);
% compute single-side amplitude spectrum 
% AC component will be doubled, and DC component will be kept as the same
X=2*abs(fft(x,N))/N;X(1)=X(1)/2; 
% map the frequency index  up to the folding frequency to the frequency in Hz
f=[0:1:N/2-1]*fs/N;           
%down sampling
y=x(1:M:N);
NM=length(y);                        % length of the down sampled data
% compute single-side amplitude spectrum for the down sampled signal
Y=2*abs(fft(y,NM))/length(y);Y(1)=Y(1)/2;
% map the frequency index to the frequency in Hz
fsM=[0:1:NM/2-1]*(fs/M)/NM;  
subplot(2,1,1);plot(f,X(1:1:N/2));grid; xlabel('Frequency (Hz)');
subplot(2,1,2);plot(fsM,Y(1:1:NM/2));grid; xlabel('Frequency (Hz)');
figure
w=filter(B,1,x);                    % anti-alising filteringh
% compute single-side amplitude spectrum for the filtered signal
W=2*abs(fft(w,N))/N;W(1)=W(1)/2;  
% down sampling 
y=w(1:M:N);
NM=length(y);
% compute single-side amplitude spectrum for the down sampled signal
Y=2*abs(fft(y,NM))/NM;Y(1)=Y(1)/2;
% plot spectrums
subplot(2,1,1);plot(f,W(1:1:N/2));grid; xlabel('Frequency (Hz)');
subplot(2,1,2);plot(fsM,Y(1:1:NM/2));grid; xlabel('Frequency (Hz)');
