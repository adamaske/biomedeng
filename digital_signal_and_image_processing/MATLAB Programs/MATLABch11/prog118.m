% MATLAB Program 11.8 SDM implementation in Section 11.3.2
clear all; close all;clc
ntotal=512; %Number of samples
n=0:ntotal;
L=8; %Oversampling factor
nL=0:ntotal*L;numb=3;A=2^(numb-1)-1; %Peak value
f1=150;C1=0.5*A;f2=175;C2=A*0.3;f3=200;C3=A*0.2;%Frequencies and amplitudes
fmax=500;fs=1000; T=1/fs% Sampling rte and sampling period
fsL=L*fs;TL=1/fsL; % Oversampling rate and sampling period
% Sampling at fs-1000 Hz
x=C1*sin(2*pi*f1*n*T)+C2*sin(2*pi*f2*T*n+pi/6)+C3*sin(2*pi*f3*T*n+pi/4);
xq=round(x); %Quantization
NN=length(n);
M=32*L;nd=M/L; %Delay in terms of samples for anti-filtering
B=firwd(2*M+1,1,2*pi*fmax/fsL,0,4);% Deisgn of anti-aliasing filter
figure(1)
freqz(B,1,1000,fsL);
% oversampling
xx=C1*sin(2*pi*f1*nL*TL)+C2*sin(2*pi*f2*nL*TL+pi/6)+C3*sin(2*pi*f3*nL*TL+pi/4);
% the first-order SDM processing
   yq=zeros(1,ntotal*L+1+1); %Initilizign the buffer
   y=yq; 
for i=1:ntotal*L
    y(i+1)=(xx(i+1)-yq(i))+y(i);
    yq(i+1)=round(y(i+1));
end
xxq=yq(1:ntotal*L+1); %Signal Quantization
% down sampling
y=filter(B,1,xxq);
yd=y(1:L:length(y));
f=[0:ntotal-1]*fs/NN;
figure (2)
subplot(3,2,1);plot(n,x,'k');grid;axis([0 500 -5 5]);ylabel('x(t)');
Ak=2*abs(fft(x))/NN; Ak(1)=Ak(1)/2;
subplot(3,2,2);plot(f(1:NN/2),log10(Ak(1:NN/2)),'k');grid;
axis([0 500 -3 2]);ylabel('X(f)');
subplot(3,2,3);plot(n,xq,'k');grid;axis([0 500 -5 5]);ylabel('xq(n)');
Ak=2*abs(fft(xq))/NN; Ak(1)=Ak(1)/2;
subplot(3,2,4);plot(f(1:NN/2),log10(Ak(1:NN/2)),'k');grid
axis([0 500 -3 2]);ylabel('Xq(f)');
subplot(3,2,5);plot(n,yd,'k');grid;axis([0 500 -5 5]);ylabel('yq(n)');
xlabel('Sample number');
Ak=2*abs(fft(yd))/NN; Ak(1)=Ak(1)/2;
subplot(3,2,6);plot(f(1:NN/2),log10(Ak(1:NN/2)),'k');grid
axis([0 500 -3 2]);ylabel('Yq(f)');xlabel('Frequency (Hz)');
figure (3)
plot(n(1:50),x(1:50),'k','LineWidth',2); hold
stairs(n(1:50),xq(1:50),'b');
stairs(n(1:50),yd(1+nd:50+nd),'r','LineWidth',2);
axis([0 50 -5 5]);grid;xlabel('Sample number');ylabel('Amplitudes');
snr(x,xq);
snr(x(1:ntotal-nd),yd(1+nd:ntotal));