% MATLAB Program 12.1
% This program is written for implementing subband coding analysis and
% synthesis using two subbands
%initialize
close all; clear all;clc
%Smith-Barnwell PR-CQF 8-taps
h0=[0.0348975582178515 -0.01098301946252854 -0.06286453934951963 ...
    0.223907720892568 0.556856993531445 0.357976304997285 ...
    -0.02390027056113145 -0.07594096379188282]; 
%Smith-Barnwell PR-CQF 16-taps
%h0=[0.02193598203004352 0.001578616497663704 -0.06025449102875281 ...
%    -0.0118906596205391 0.137537915636625 0.05745450056390939 ...
%    -0.321670296165893  -0.528720271545339 -0.295779674500919 ...
%    0.0002043110845170894 0.0290669978946796 -0.03533486088708146 ...
%    -0.006821045322743358 0.02606678468264118 0.001033363491944126 ...
%    -0.01435930957477529];
% Read data file "orig.dat" with sampling rate of 8 kHz
load orig.dat; % load speech data
M=2; % Down sample factor
N=length(h0); PNones=ones(1,N); PNones(2:2:N)=-1;
h1=h0.*PNones;
h1=h1(N:-1:1);
g0=-h1.*PNones;
g1=h0.*PNones;
disp('check R(z)+R(-z) =>');
xcorr(h0,h0)
sum(h0.*h0)
w=0:pi/1000:pi;
fh0=freqz(h0,1,w);
fh1=freqz(h1,1,w);
plot(w,abs(fh0),'k',w,abs(fh1),'k');grid; axis([0 pi 0 1.2]);
xlabel('Frequency in radians');ylabel('Magnitude)')
figure
speech=orig;
%analysis
sb_low=filter(h0,1,speech);
sb_high=filter(h1,1,speech);
% down sample
sb_low=sb_low(1:M:length(sb_low));
sb_high=sb_high(1:M:length(sb_high));
% Quantization
%  sb_low=round((sb_low/2^15)*2^9)*2^(15-9); %quantization with 10 bits
%  sb_high=round((sb_high/2^15)*2^5)*2^(15-5); %qunntization with 6 bits
% Syntheiss
low_sp=zeros(1,M*length(sb_low)); % up sampling
low_sp(1:M:length(low_sp))=sb_low;
high_sp=zeros(1,M*length(sb_high));
high_sp(1:M:length(high_sp))=sb_high;
low_sp=filter(g0,1,low_sp);
high_sp=filter(g1,1,high_sp);
rec_sig=2*(low_sp+high_sp);
% signal alignment for SNR caculations
speech=[zeros(1,N-1) speech]; %align the signal
subplot(4,1,1);plot(speech,'k');grid,ylabel('x(n)');axis([0 20000 -20000 20000]);
subplot(4,1,2);plot(sb_low,'k');grid,ylabel('x0(m)');axis([0 10000 -20000 20000]);
subplot(4,1,3);plot(sb_high,'k');grid, ylabel('x1(m)');axis([0 10000 -2000 2000]);
subplot(4,1,4);plot(rec_sig,'k');grid, ylabel('xbar(n)'),xlabel('Sample Number');
axis([0 20000 -20000 20000]);
NN=min(length(speech),length(rec_sig));
err=rec_sig(1:NN)-speech(1:NN);
SNR=sum(speech.*speech)/sum(err.*err);
disp('PR reconstruction SNR dB=>');
SNR=10*log10(SNR)
