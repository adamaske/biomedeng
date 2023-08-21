% MATLAB Program 11.5 
% Polyphase implementation for downsampling for Figure 11.22
% down sampling filter  ( see Chapter 7  for FIR filter design)
close all; clear all;clc;
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
% Compute single-side amplitude spectrum 
% AC component will be doubled, and DC component will be kept as the same
X=2*abs(fft(x,N))/N;X(1)=X(1)/2; 
% map the frequency index  up to the folding frequency to the frequency in Hz
f=[0:1:N/2-1]*fs/N;        
%down sampling using the polyphase method
w0=x(1:M:N); p0=B(1:M:length(B)); % down sampling
w1=filter([0 1],1,x); % delay one sample
w1=w1(1:2:N); p1=B(2:M:length(B)); % down sampling 
y=filter(p0,1,w0)+filter(p1,1,w1);
NM=length(y);                        % length of the down sampled data
% compute single-side amplitude spectrum for the down sampled signal
Y=2*abs(fft(y,NM))/NM;Y(1)=Y(1)/2;
% map the frequency index to the frequency in Hz
fsM=[0:1:NM/2-1]*(fs/M)/NM;  
% plot spectrums
subplot(2,1,1);plot(f,X(1:1:N/2));grid; xlabel('Frequency (Hz)');
subplot(2,1,2);plot(fsM,Y(1:1:NM/2));grid; xlabel('Frequency (Hz)');
