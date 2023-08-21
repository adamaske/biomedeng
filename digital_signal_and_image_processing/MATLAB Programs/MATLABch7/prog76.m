% MATLAB Program 7.6 for Eaxmple 7.11
close all; clear all;
N=35; Ftype=4; WnL=0.3125*pi; WnH=0.7125*pi; Wtype=5;fs=8000;
Bblack=firwd(N,Ftype,WnL,WnH,Wtype);
freqz(Bblack,1,512,fs);
axis([0 fs/2 -120 10]);

disp('Hit "enter" to perform bandstop filtering of speech=>');
pause

figure
%
fs=8000;T=1/fs;
load we.dat
x=we;
y=filter(Bblack,1,x);
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
ylabel('Bandrejected speech');
xlabel('Sample number');





