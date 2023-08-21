clear all
close all
fs=8250;
fm=1000;
fcr=99000;  % carrier frequency

% am=(1+0.5*cos(2*pi*fm*t)).*cos(2*pi*fcr*t)
t1=0:1/(5*fcr):0.01;
am_c=(1+0.8*sin(2*pi*fm*t1));
am_c=am_c.*cos(2*pi*fcr*t1);
t=0:1/fs:0.01;
am=(1+0.8*sin(2*pi*fm*t));
am=am.*cos(2*pi*fcr*t);
xf_c=abs(fft(am_c))/length(t1);
f1=[0:1:length(t1)-1]*5*fcr/length(t1);
xf=abs(fft(am))/length(t);
f=[0:1:length(t)-1]*fs/length(t);
subplot(2,2,1);plot(t1,am_c,'k');grid
xlabel('Time (sec.)');
ylabel('AM signal');
subplot(2,2,2);plot(f1,xf_c,'k');grid
xlabel('Frquency (Hz)');
ylabel('Spectrum of x(t)');
axis([90000 110000 0 1]);
subplot(2,2,3);plot(t,am,'k');grid
ylabel('m(n)');
xlabel('Time (sec.)');
subplot(2,2,4);plot(f,xf,'k');grid;
xlabel('Frequency (Hz)');
ylabel('Spectum of x(n)');


