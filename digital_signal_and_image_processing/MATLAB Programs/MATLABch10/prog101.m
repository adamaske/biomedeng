%MATLAB Program 10.1 for Section 10.1
clear all;close all
disp('load speech: We');
load speech.dat;                                          % provided by your instructor
sig = speech;                                              
lg=length(sig);                                      % length of the speech data
t=[0:1:lg-1];                                          % time index
sig=5*sig/max(abs(sig));                      % normalized signal to between -5 to 5 
Emax = max(abs(sig));
Erms = sqrt( sum(sig .* sig) / length(sig))
k=Erms/Emax
disp('20*log10(k)=>');
k = 20*log10(k)
bits = input('input number of bits =>');
lg = length(sig);
% encoding 
for x=1:lg
   [indx(x) qy] = mtrdenc(bits, 5, sig(x));
end
disp('Finished and transmitted');
% decoding
for x=1:lg
   qsig(x) = mtrddec(bits, 5, indx(x));
end
disp('decoding finished');
  qerr = sig-qsig;              % calculate quantization error
subplot(3,1,1);plot(t, sig);grid
ylabel('Speech');axis([0 lg -5 5]);
subplot(3,1,2);plot(t, qsig);grid
ylabel('Quantized speech');axis([0 lg -5 5]);
subplot(3,1,3);plot(qerr);grid
axis([0 lg -0.5 0.5]);
ylabel('Qunatized error');xlabel('Sample number');
disp('signal to noise ratio due to quantization noise')
snr(sig,qsig);                   % calculate signal to noise ratio due to quantization
