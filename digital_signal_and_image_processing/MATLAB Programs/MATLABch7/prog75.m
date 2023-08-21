% MATLAB Program 7.5 for Example 7.10
close all; clear all;
N=25; Ftype=3; WnL=0.2625*pi; WnH=0.725*pi; Wtype=4;fs=8000;
Bham=firwd(N,Ftype,WnL,WnH,Wtype);
freqz(Bham,1,512,fs);
axis([0 fs/2 -130 10]);

disp('Hit "enter" to perform bandpass filtering of speech=>');
pause
figure
%
fs=8000;T=1/fs;
load we.dat
x=we;
y=filter(Bham,1,x);
N=length(x);
f=[0:N/2]*fs/N;
Axk=2*abs(fft(x))/N;Axk(1)=Axk(1)/2;
subplot(2,1,1); plot(f,Axk(1:N/2+1));grid
xlabel('Frequency (Hz)'); ylabel('Amplitude X(f)| ');
Ayk=2*abs(fft(y))/N;Ayk(1)=Ayk(1)/2;
subplot(2,1,2);plot(f,Ayk(1:N/2+1));
xlabel('Frequency (Hz)'); ylabel('Amplitude |Y(f)| ');grid;
figure
subplot(2,1,1);plot(x);grid;axis([0 length(we) -10000 10000]);
ylabel('Speech');
subplot(2,1,2);plot(y);grid;axis([0 length(we) -10000 10000]);
ylabel('Bandpassed speech');
xlabel('Sample number');