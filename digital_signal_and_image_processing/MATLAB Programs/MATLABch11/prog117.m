% MATLAB Program 11.7 for Oversampling ADC in Section 11.3.1
clear all; close all;clc
ntotal=512;
n=0:ntotal; % Number of samples
L=4; % over saampling factor
nL=0:ntotal*L; % Number of samples for over sampling 
numb=3; % Number of bits
A=2^(numb-1)-1; %Peak value
f1=150;C1=0.5*A;f2=175;C2=A*0.3;f3=200;C3=A*0.2; %Frequencies and amplitides
fmax=500;fs=1000;T=1/fs; % Maximum frequency, sampling rate, sampling period
fsL=L*fs;TL=1/fsL;%Over sampling rate, and over sampling period
% Sampling at fs=1000 Hz
x=C1*sin(2*pi*f1*n*T)+C2*sin(2*pi*f2*T*n+pi/6)+C3*sin(2*pi*f3*T*n+pi/4);
xq=round(x); %Qunrized signal at the minimum sampling rate
NN=length(n);
f=[0:ntotal-1]*fs/NN;
M=32*L;nd=M/L; %Number of delay in samples due to anti-aliasing filtering 
B=firwd(2*M+1,1,2*pi*fmax/fsL,0,4); % anti-aliasing filter design (ensure 5% normalized transition BW) 
figure(1);freqz(B,1,1000,fsL)
% Oversampling
xx=C1*sin(2*pi*f1*nL*TL)+C2*sin(2*pi*f2*nL*TL+pi/6)+C3*sin(2*pi*f3*nL*TL+pi/4);%+0.5*randn(1,length(nL));
xxq=round(xx); % Quantized signal
% down sampling
y=filter(B,1,xxq);%Anti-aliasing filtering
yd=y(1:L:length(y));% down sample
figure (2)
subplot(3,2,1);plot(n,x,'k');grid;axis([0 500 -5 5]);ylabel('x(t)')
Ak=2*abs(fft(x))/NN; Ak(1)=Ak(1)/2
subplot(3,2,2);plot(f(1:NN/2),log10(Ak(1:NN/2)),'k');grid;ylabel('X(f)');axis([0 500 -4 2])
subplot(3,2,3);plot(n,xq,'k');grid;axis([0 500 -5 5]);ylabel('xq(n)');
Ak=2*abs(fft(xq))/NN; Ak(1)=Ak(1)/2
subplot(3,2,4);plot(f(1:NN/2),log10(Ak(1:NN/2)),'k');grid;ylabel('Xq(f)');axis([0 500 -4 2])
subplot(3,2,5);plot(n,yd,'k');grid;axis([0 500 -5 5]);ylabel('yq(n)');
xlabel('Sample number');
Ak=2*abs(fft(yd))/NN; Ak(1)=Ak(1)/2
subplot(3,2,6);plot(f(1:NN/2),log10(Ak(1:NN/2)),'k');grid;ylabel('Yq(f)');axis([0 500 -4 2])
xlabel('Frequency (Hz)');
figure (3)
plot(n(1:50),x(1:50),'k','LineWidth',2); hold % plot of first 50 samples
stairs(n(1:50),xq(1:50),'b');
stairs(n(1:50),yd(1+nd:50+nd),'r','LineWidth',2);grid
axis([0 50 -5 5]);xlabel('Sample number');ylabel('Amplitudes')
snr(x,xq);
snr(x(1:ntotal-nd),yd(1+nd:ntotal));