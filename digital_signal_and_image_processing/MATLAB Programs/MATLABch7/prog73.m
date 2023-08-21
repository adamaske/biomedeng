% MATLAB Program 7.3 for Example 7.8
close all; clear all;
N=25; Ftype=1; WnL=0.5*pi; WnH=0; Wtype=1;fs=8000;
%design using the rectangular window;
Brec=firwd(N,Ftype,WnL,WnH,Wtype);
N=25; Ftype=1; WnL=0.5*pi; WnH=0; Wtype=4;
%design using the Hamming window; 
Bham=firwd(N,Ftype,WnL,WnH,Wtype);
[hrec,f]=freqz(Brec,1,512,fs);
[hham,f]=freqz(Bham,1,512,fs);
prec=180*unwrap(angle(hrec))/pi;
pham=180*unwrap(angle(hham))/pi;
subplot(2,1,1);
plot(f,20*log10(abs(hrec)),'-.',f,20*log10(abs(hham)));grid
axis([0 4000 -100 10]);
xlabel('Frequency (Hz)'); ylabel('Magnitude Response (dB)');
subplot(2,1,2);
plot(f,prec,'-.',f,pham);grid
xlabel('Frequency (Hz)'); ylabel('Phase (degrees)');

disp('Hit "enter" to perform lowpass filtering of speech=>');
pause
figure
%
fs=8000;T=1/fs;
load we.dat
x=we;
y=filter(Brec,1,x);
N=length(x);
f=[0:N/2]*fs/N;
Axk=2*abs(fft(x))/N;Axk(1)=Axk(1)/2;
subplot(2,1,1); plot(f,Axk(1:N/2+1),'k');grid
xlabel('Frequency (Hz)'); ylabel('Amplitude X(f)| ');
Ayk=2*abs(fft(y))/N;Ayk(1)=Ayk(1)/2;
subplot(2,1,2);plot(f,Ayk(1:N/2+1),'k');
xlabel('Frequency (Hz)'); ylabel('Amplitude |Y(f)| ');grid;
figure
subplot(2,1,1);plot(x,'k');grid;axis([0 length(we) -10000 10000]);
ylabel('Speech');
subplot(2,1,2);plot(y,'k');grid;axis([0 length(we) -10000 10000]);
ylabel('Lowpassed speech');
xlabel('Sample number');