%MATLAB Program 9.2 for Section 9.3.2 
close all; clear all
%Design unknown system
fs=8000; T=1/fs;                                      % sampling rate and sampling period
% bandpass filter design 
%for the assumed unknown system using BLT method (see chapter 8)
wd1=1400*2*pi; wd2=1600*2*pi;
wa1=(2/T)*tan(wd1*T/2); wa2=(2/T)*tan(wd2*T/2);
BW=wa2-wa1;
w0=sqrt(wa2*wa1);
[B,A]=lp2bp([1],[1 1.4141 1],w0,BW);
[b,a]=bilinear(B,A,fs);
freqz(b,a,512,fs); axis([0 fs/2 -80 1]); % frequency response plots
figure
t=0:T:0.1;                 %  generate time vector
x=cos(2*pi*500*t)+sin(2*pi*1500*t)+cos(2*pi*2500*t+pi/4);
d=filter(b,a,x);        % produce unknown system output
mu=0.01;                % convergenece factor
w=zeros(1,21); y=zeros(1,length(t)); % initialize adaptive filter coefficients and output
e=y;                                                  % initialize the error vector
% Perform adaptive filtering using LMS algorithm
for m=22:1:length(t)-1
      sum=0;
     for i=1:1:21
      sum=sum+w(i)*x(m-i);
     end
      y(m)=sum;
      e(m)=d(m)-y(m);
      for i=1:1:21
      w(i)=w(i)+2*mu*e(m)*x(m-i);
     end
end
% calculate single-side amplitude spectrum for the input
 X=2*abs(fft(x))/length(x);X(1)=X(1)/2; 
% calculate single-side amplitude spectrum for the unknown system output
 D=2*abs(fft(d))/length(d);D(1)=D(1)/2;
% calculate single-side amplitude spectrum for the adaptive filter output
 Y=2*abs(fft(y))/length(y);Y(1)=Y(1)/2;
% map the frequency index to its frequency in Hz
 f=[0:1:length(x)/2]*fs/length(x);
% plot signals and spectrums
subplot(4,1,1), plot(x);grid; axis([0 length(x) -3 3]);
 ylabel('System input');
 subplot(4,1,2), plot(d);grid; axis([0 length(x) -1.5 1.5]); 
 ylabel('System output');
 subplot(4,1,3),plot(y);grid; axis([0 length(y) -1.5 1.5]); 
 ylabel('ADF output')
 subplot(4,1,4),plot(e);grid; axis([0 length(e) -1.5 1.5]);
 ylabel('Error'); xlabel('Number of samples')
 figure
subplot(3,1,1),plot(f,X(1:length(f)));grid; ylabel('Syst. input spect.')
subplot(3,1,2),plot(f,D(1:length(f)));grid; ylabel('Syst. output spect.')
subplot(3,1,3),plot(f,Y(1:length(f)));grid
 ylabel('ADF output spect.'); xlabel('Frequency (Hz)');
