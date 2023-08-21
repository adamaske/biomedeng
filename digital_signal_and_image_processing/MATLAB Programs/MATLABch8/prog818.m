%MATLAB Program 8.18 for a single tone generation in Section 8.11.1
fs=8000;    % sampling rate
t=0:1/fs:1;     % time vector for 1 second
x=zeros(1,length(t));   %initialize input to be zero
x(1)=1; %  set up impulse function
y=filter([0 0.707107],[1 -1.414214 1],x); % perform filtering
subplot(2,1,1);plot(t(1:400),y(1:400));grid
ylabel('y(n) 1 kHz tone'); xlabel('time (second)')
Ak=2*abs(fft(y))/length(y);Ak(1)=Ak(1)/2; % one-side amplitude spectrum
f=[0:1:(length(y)-1)/2]*fs/length(y);% indices to frequencies (Hz) for plot
subplot(2,1,2);plot(f,Ak(1:(length(y)+1)/2));grid
ylabel('Spectrum for y(n)'); xlabel('frequency (Hz)')
