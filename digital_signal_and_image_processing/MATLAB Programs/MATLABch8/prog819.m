%MATLAB Program 8.19 for DTMF tone generation in Section 8.11.2
close all; clear all
fs=8000;          % sampling rate 
t=0:1/fs:1;       % 1 second time vector
x=zeros(1,length(t));    % initialize input to be zero
x(1)=1;    % set-up impulse function
% generate 852-Hz tone
y852=filter([0 sin(2*pi*852/fs)],[1 -2*cos(2*pi*852/fs) 1],x);    
% generate 1209-Hz tone
y1209=filter([0 sin(2*pi*1209/fs) ],[1 -2*cos(2*pi*1209/fs) 1],x); % filtering
y7=y852+y1209;     % generate DTMF tone
subplot(2,1,1);plot(t(1:400),y7(1:400));grid
ylabel('y(n) DTMF: number 7');
xlabel('time (second)')
Ak=2*abs(fft(y7))/length(y7);Ak(1)=Ak(1)/2;   % one-side amplitude spectrum
f=[0:1:(length(y7)-1)/2]*fs/length(y7);   % map indices to frequencies (Hz) for plot
subplot(2,1,2);plot(f,Ak(1:(length(y7)+1)/2));grid
ylabel('Spectrum for y7(n)');
xlabel('frequency (Hz)');
