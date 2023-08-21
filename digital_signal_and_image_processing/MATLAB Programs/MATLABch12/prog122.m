% MATLAB Program 12.2 (see Section 13.7)
close all; clear all;clc
t=0:1:1023;t=t/8000;
x=100*cos(40*2*pi*t)+10*randn(1,1024);
h0=[0.230377813308896   0.714846570552915   0.630880767929859 ...
    -0.027983769416859  -0.187034811719092   0.030841381835561 ....
    0.032883011666885  -0.010597401785069];
N=1024; nofseg=1
rec_sig=[]; rec_sig2t1=[]; rec_sig4t1=[]; rec_sig8t1=[]; rec_sig16t1=[];
for i=1:nofseg
    sp=x((i-1)*1024+1:i*1024);
    w=dwt(h0,sp,10); 
% Quantization
    wmax=round(max(abs(w)));
    wcode=round(2^15*w/wmax); % 16-bit code for storage
    w=wcode*wmax/2^15; % recovered wavelet coefficients 
    w(513:1024)=zeros(1,512); % 2:1 compressin ratio
    sig_rec2t1=idwt(h0,w,10);
    rec_sig2t1=[rec_sig2t1 sig_rec2t1'];
    w(257:1024)=0; % 4:1 compressin ratio
    sig_rec4t1=idwt(h0,w,10);
    rec_sig4t1=[rec_sig4t1 sig_rec4t1'];
    w(129:1024)=0; % 8:1 compressin ratio
    sig_rec8t1=idwt(h0,w,10);
    rec_sig8t1=[rec_sig8t1 sig_rec8t1'];
    w(65:1024)=0; % 8:1 compressin ratio
    sig_rec16t1=idwt(h0,w,10);
    rec_sig16t1=[rec_sig16t1 sig_rec16t1'];
end
subplot(5,1,1),plot(t,x,'k'); axis([0 0.12 -120 120]);ylabel('x(n)');
subplot(5,1,2),plot(t,rec_sig2t1,'k'); axis([0 0.12 -120 120]);ylabel('2:1');
subplot(5,1,3),plot(t,rec_sig4t1,'k'); axis([0 0.12 -120 120]);ylabel(4:1);
subplot(5,1,4),plot(t,rec_sig8t1,'k'); axis([0 0.12 -120 120]);ylabel('8:1');
subplot(5,1,5),plot(t,rec_sig16t1,'k'); axis([0 0.12 -120 120]);ylabel('16:1');
xlabel('Time (Sec.)')
NN=min(length(x),length(rec_sig2t1)); axis([0 0.12 -120 120]);
err=rec_sig2t1(1:NN)-x(1:NN);
SNR=sum(x.*x)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)
