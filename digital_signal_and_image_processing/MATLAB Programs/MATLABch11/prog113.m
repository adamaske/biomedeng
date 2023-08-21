%MATLAB Program 11.3
close all; clear all;clc;
% down sampling filter 
Bdown=firwd(159,1,2*pi*1250/24000,0,4);
% generate 2048 samples with fs=8000 Hz
fs=8000;                                                      % original sampling rate
N = 2048;                                                    % the number of samples
L=3;                                                             % up sampling factor 
M=8;                                                            % down sampling factor
n=0:1:N-1;                                                   % generate the time index
x=5*sin(n*pi/4)+cos(5*n*pi/8);                 % generate the test signnal
% up sampling by a factor of L
w1=zeros(1,L*N);
for n=0:1:N-1
  w1(L*n+1)=x(n+1);
end
NL= length(w1);                                          % length of up sampled data 
W1=2*abs(fft(w1,NL))/NL;W1(1)=W1(1)/2; % compute one-side amplitude spectrum
f=[0:1:NL/2-1]*fs*L/NL;  % map frequency index to its frequency in Hz
subplot(3,1,1);plot(f,W1(1:1:NL/2));grid
xlabel('Frequency (Hz)');
w2=filter(Bdown,1,w1);         % perform anti-aliasing for down sampling
W2=2*abs(fft(w2,NL))/NL;W2(1)=W2(1)/2; % compute one-side amplitude spectrum
y2=w2(1:M:NL);
NM=length(y2);                                        % length of down sampled data
Y2=2*abs(fft(y2,NM))/NM;Y2(1)=Y2(1)/2;% compute one-side amplitude spectrum
% map frequency index to its frequency in Hz  before down sampling
fbar=[0:1:NL/2-1]*24000/NL; 
% map frequency index to its frequency in Hz
fsM=[0:1:NM/2-1]*(fs*L/M)/NM;
subplot(3,1,2);plot(f,W2(1:1:NL/2));grid; xlabel('Frequency (Hz)');
subplot(3,1,3);plot(fsM,Y2(1:1:NM/2));grid; xlabel('Frequency (Hz)');
