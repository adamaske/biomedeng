% MATLAB Program 7.4 for Example 7.9
%
close all; clear all
N=25; Ftype=2; WnL=0; WnH=0.5*pi; Wtype=3;fs=8000;
Bhan=firwd(N,Ftype,WnL,WnH,Wtype);
freqz(Bhan,1,512,fs);
axis([0 fs/2 -120 10]);

disp('Hit "enter" to perform highpass filtering of speech=>');
pause
figure
%
fs=8000;T=1/fs;
load we.dat
x=we;
y=filter(Bhan,1,x);
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
ylabel('Highpassed speech');
xlabel('Sample number');
