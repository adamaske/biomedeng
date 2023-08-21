% MATLAB Program 11.4
close all; clear all; clc
% generate 2048 samples with fs=44100 Hz
fs= 44100;                                                 % original sampling rate
T=1/fs;                                                       % sampling period
N=2048;                                                     % number of samples
L=4; 
fsL=fs*L;                                                % up sampling rate 
%Up sampling filter  (see Chapter 7 for FIR filter design)
Bup=firwd(97,1,2*19025*pi/fsL,0,4);
n=0:1:N-1;                                               % generate time indices
x=5*sin(2*pi*16000*n*T);                     % generate the test signal
% up sampling by a factor of L
w=zeros(1,L*N);
for n=0:1:N-1
  w(L*n+1)=x(n+1);
end
NL=length(w);                                        % number of the up sampled data
W=2*abs(fft(w,NL))/NL;W(1)=W(1)/2; % compute one-side amplitude spectrum
f=[0:1:NL/2-1]*fs*L/NL; % map the frequency index to frequency in Hz up fs/2
f=f/1000;     % convert to kHz
%Interpolation
y=filter(Bup,1,w);         % perform interpolation filter
Y=2*abs(fft(y,NL))/NL;Y(1)=Y(1)/2; % compute one-side amplitude spectrum
subplot(2,1,1);plot(f,W(1:1:NL/2));grid; 
xlabel('Frequency (kHz)'); axis([0 f(length(f)) 0 2]);
subplot(2,1,2);plot(f,Y(1:1:NL/2));grid;
xlabel('Frequency (kHz)');axis([0 f(length(f))  0 2]);
figure
subplot(2,2,1);stem(x(21:30));grid
xlabel('Number of Samples');ylabel('x(n)');
subplot(2,2,2);stem(w(81:120));grid
xlabel('Number of Samples'); ylabel('w(n)');
subplot(2,2,3);stem(y(81:120));grid
xlabel('Number of Samples'); ylabel('y(n)')
subplot(2,2,4);stairs([80:1:119]*1000*T,y(81:120));grid
xlabel('Time (ms)'); ylabel('y(t)')
