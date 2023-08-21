%MATLAB Program 9.3 for Section 9.3.3
% Line ehancement using linear prediction
close all; clear all
fs=8000; T=1/fs;                           % sampling rate and sampling period
t=0:T:0.1;                                      % 1 second time instant 
n=randn(1,length(t));                     % generate Gaussian random noise 
d=cos(2*pi*500*t)+n;                    % generate 500-Hz tone plus noise
x=filter([ 0 0 0 0  0 0 0 1 ],1,d);      %delay filter
mu=0.001;                                       % initialize the step size for LMS algorithms
w=zeros(1,21);                               % initialize the adaptive filter coefficients
y=zeros(1,length(t));                      % initialize the adaptive filter output
e=y;                                                 % initialize the errro vector
%perfrom adaptive filtering using the LMS algorithm
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
% calculate the single-side amplitude spectrum for corrupted signal
 D=2*abs(fft(d))/length(d);D(1)=D(1)/2;
% calculate the single-side amplitude spectrum for enhanced signal
 Y=2*abs(fft(y))/length(y);Y(1)=Y(1)/2;
% map the frequency index to its frequency in Hz
 f=[0:1:length(x)/2]*8000/length(x);
% plot the signals and spectrums
 subplot(2,1,1), plot(d);grid; axis([0 length(x) -2.5 2.5]); ylabel('Noisy signal');
 subplot(2,1,2),plot(y);grid; axis([0 length(y) -2.5 2.5]);
 ylabel('ADF output (enhanced signal)'); xlabel('Number of samples')
 figure
subplot(2,1,1),plot(f,D(1:length(f)));grid; axis([0 fs/2 0 1.5]);
 ylabel('Noisy signal spectrum')
subplot(2,1,2),plot(f,Y(1:length(f)));grid; axis([0 fs/2 0 1.5]);
 ylabel('ADF output spectrum'); xlabel('Frequency (Hz)');
