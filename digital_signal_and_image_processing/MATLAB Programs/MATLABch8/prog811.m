%MATLAB Program 8.11 for simulating the digital equalizer (Section 8.5
close all; clear all
% these filter coefficients (Butterworth type, designed uisng BLT)
B0=[0.0031954934   0  -0.0031954934]; A0=[1.0000000000  -1.9934066716   0.9936090132];
B1=[0.0063708102    0  -0.0063708102]; A1=[1.0000000000  -1.9864516324   0.9872583796];
B2=[0.0126623878    0  -0.0126623878]; A2=[1.0000000000  -1.9714693192   0.9746752244];
B3=[0.0310900413     0  -0.0310900413]; A3=[ 1.0000000000  -1.9181849043  0.9378199174];
B4=[ 0.0746111954   0.000000000  -0.0746111954]; 
A4=[1.0000000000  -1.7346085867   0.8507776092];
B5=[0.1663862883   0.0000000000  -0.1663862884];
A5=[1.0000000000  -1.0942477187   0.6672274233];
B6=[0.3354404899   0.0000000000  -0.3354404899];
A6=[1.0000000000   0.7131366534   0.3291190202];

[h0,f]=freqz(B0,A0,2048,44100);
[h1,f]=freqz(B1,A1,2048,44100);
[h2,f]=freqz(B2,A2,2048,44100);
[h3,f]=freqz(B3,A3,2048,44100);
[h4,f]=freqz(B4,A4,2048,44100);
[h5,f]=freqz(B5,A5,2048,44100);
[h6,f]=freqz(B6,A6,2048,44100);
loglog(f,abs(h0),f,abs(h1), f,abs(h2), ...
f,abs(h3),f,abs(h4),f,abs(h5),f,abs(h6));
xlabel('Frequency (Hz)');
ylabel('Filter Gain');grid
axis([10 10^5  10^(-6)  1]);
figure(2)
g0=10;g1=10;g2=0;g3=0;g4=0;g5=10;g6=10;
p0=0;p1=pi/14;p2=2*p1;p3=3*p1;p4=4*p1;p5=5*p1;p6=6*p1;
n=0:1:20480;                             % indices of samples
fs=44100;                                   % sampling rate
x=sin(2*pi*100*n/fs)+sin(2*pi*200*n/fs+p1)+...
     sin(2*pi*400*n/fs+p2)+sin(2*pi*1000*n/fs+p3)+...
     sin(2*pi*2500*n/fs+p4)+sin(2*pi*6000*n/fs+p5)+...
     sin(2*pi*15000*n/fs+p6);       % generate test audio signals
y0=filter(B0,A0,x);                      % band pass filter 0
y1=filter(B1,A1,x);                      % bandpass filter 1
y2=filter(B2,A2,x);                      % bandpass filter 2
y3=filter(B3,A3,x);                      % bandpass filter 3
y4=filter(B4,A4,x);                      % bandpass filter 4
y5=filter(B5,A5,x);                      % bandpass filter 5
y6=filter(B6,A6,x);                      % bandpass filter 6
y=g0.*y0+g1.*y1+g2.*y2+g3.*y3+g4.*y4+g5.*y5+g6.*y6+x;   % equalizer output
N=length(x);
Axk=2*abs(fft(x))/N;Axk(1)=Axk(1)/2;    % one side amplitude spectrum of the input
f=[0:N/2]*fs/N;
subplot(2,1,1);loglog(f,Axk(1:N/2+1));
title('Audio spectrum');
axis([10 100000 0.00001 100]);grid;
Ayk=2*abs(fft(y))/N; Ayk(1)=Ayk(1)/2; % one side amplitude spectrum of the output
 subplot(2,1,2);loglog(f,Ayk(1:N/2+1));  
xlabel('Frequency (Hz)');
title('Equalized audio spectrum');
axis([10 100000 0.00001 100]);grid;
