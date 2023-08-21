% MATLAB Program 12.3 (See Section 12.7)
close all; clear all;clc
load orig.dat
h0=[0.230377813308896   0.714846570552915   0.630880767929859 ...
    -0.027983769416859  -0.187034811719092   0.030841381835561 ....
    0.032883011666885  -0.010597401785069];
N=length(orig);
nofseg=ceil(N/1024);
speech=zeros(1,nofseg*1024);
speech(1:N)=orig(1:N);% making the speech length to be multiple of 1024 samples
rec_sig=[];
for i=1:nofseg
    sp=speech((i-1)*1024+1:i*1024);
    w=dwt(h0,sp,10);
% Quantization
    w=(round(2^15*w/2^15))*2^(15-15);
    w(513:1024)=zeros(1,512); % Omitting the high frequency coefficients
    sp_rec=idwt(h0,w,10);
    rec_sig=[rec_sig sp_rec'];
end
subplot(2,1,1),plot([0:length(speech)-1],speech,'k');axis([0 20000 -20000 20000]);
ylabel('Original data x(n)');
subplot(2,1,2),plot([0:length(rec_sig)-1],rec_sig,'k');axis([0 20000 -20000 20000]);
xlabel('Sample number');ylabel('Recovered x(n) CR=2:1');
NN=min(length(speech),length(rec_sig));
err=rec_sig(1:NN)-speech(1:NN);
SNR=sum(speech.*speech)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)
