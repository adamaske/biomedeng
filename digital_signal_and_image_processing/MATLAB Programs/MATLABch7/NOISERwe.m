% MATLAB program for Section 7.4.2 (noise filtering)
close all; clear all
fs=8000;T=1/fs;
load we.dat
t=[0:length(we)-1]*T;
th=mean(we.*we)/4;
v=sqrt(th)*randn([1,length(we)]);
x=we+v;
subplot(2,1,1);plot(t,x,'k');
xlabel('Number of samples');ylabel('Sample value');grid;
N=length(x);
f=[0:N/2]*fs/N;
Axk=2*abs(fft(x))/N;Axk(1)=Axk(1)/2;
subplot(2,1,2); plot(f,Axk(1:N/2+1),'k');
xlabel('Frequency (Hz)'); ylabel('Amplitude |X(f)| ');grid;
figure
wc=2*pi*1900/8000;
B=firwd(133,1,wc,0,4);
y=filter(B,1,x);
Ayk=2*abs(fft(y))/N;Ayk(1)=Ayk(1)/2;
subplot(2,1,1); plot(t,y,'k');
xlabel('Number of samples');ylabel('Sample value');grid;
subplot(2,1,2);plot(f,Ayk(1:N/2+1),'k');
xlabel('Frequency (Hz)'); ylabel('Amplitude |Y(f)| ');grid;





