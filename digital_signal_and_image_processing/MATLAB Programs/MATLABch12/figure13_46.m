% Program for Figure 13.46
close all; clear all;clc
t=0:1:1023;
t=t/8000;fs=8000;
xx=100*cos(40*2*pi*t);
x=100*cos(40*2*pi*t)+10*randn(1,1024);
h0=daubechies(4);
N=1024;
nofseg=1;
rec_sig=[];
rec_sig2t1=[];
rec_sig4t1=[];
rec_sig8t1=[];
rec_sig16t1=[];
for i=1:nofseg
    sp=x((i-1)*1024+1:i*1024);
    w1=dwt(h0,sp,10);
    [w, p]=hardT(w1,10);
    p
    sig_rec2t1=idwt(h0,w,10);
    rec_sig2t1=[rec_sig2t1 sig_rec2t1'];
    [w, p]=hardT(w1,20);
    p
    sig_rec4t1=idwt(h0,w,10);
    rec_sig4t1=[rec_sig4t1 sig_rec4t1'];
    [w, p]=hardT(w1,40);
    p
    sig_rec8t1=idwt(h0,w,10);
    rec_sig8t1=[rec_sig8t1 sig_rec8t1'];
    [w, p]=hardT(w1,80);
    p
    sig_rec16t1=idwt(h0,w,10);
    rec_sig16t1=[rec_sig16t1 sig_rec16t1'];
end
f=[0:N-1]*fs/N;

subplot(4,1,1),plot(t,x,'k',t,xx,'r'); axis([0 0.12 -120 120]);
%A=2*abs(fft(x))/N;A(1)=A(1)/2;
%subplot(4,2,2),plot(f(1:N/20),(A(1:N/20)),'k');
subplot(4,1,2),plot(t,rec_sig2t1,'k',t,xx,'r'); axis([0 0.12 -120 120]);
%A=2*abs(fft(rec_sig2t1))/N;A(1)=A(1)/2;
%subplot(4,2,4),plot(f(1:N/20),log10(A(1:N/20)),'k');
subplot(4,1,3),plot(t,rec_sig4t1,'k',t,xx,'r'); axis([0 0.12 -120 120]);
%A=2*abs(fft(rec_sig4t1))/N;A(1)=A(1)/2;
%subplot(4,2,6),plot(f(1:N/20),(A(1:N/20)),'k');
subplot(4,1,4),plot(t,rec_sig8t1,'k',t,xx,'r'); axis([0 0.12 -120 120]);
%A=2*abs(fft(rec_sig8t1))/N;A(1)=A(1)/2;
%subplot(4,2,8),plot(f(1:N/20),(A(1:N/20)),'k');
%subplot(5,1,5),plot(t,rec_sig16t1,'k'); axis([0 0.12 -120 120]);
xlabel('Time (sec.)');
NN=min(length(x),length(rec_sig2t1)); 
%x=rec_sig2t1(1:NN)
err=x-xx(1:NN);
SNR=sum(xx.*xx)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)
x=rec_sig2t1(1:NN);
err=x-xx(1:NN);
SNR=sum(xx.*xx)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)
x=rec_sig4t1(1:NN);
err=x-xx(1:NN);
SNR=sum(xx.*xx)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)
x=rec_sig8t1(1:NN);
err=x-xx(1:NN);
SNR=sum(xx.*xx)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)