%MATLAB Program 10.4 for Section 10.2
close all; clear all
disp('load speech file');
load speech.dat;
we=speech% provided by your instructor
lg=length(we);                                         % length of the speech data
we=5*we/max(abs(we));                         % normalize the speech data 
we_nor=we/max(abs(we));		% normalization
t=[0:1:lg-1];                                             % time index
disp('mulaw companding')
mu=input('input mu =>');
for x=1:lg
  ymu(x) =mulaw(we_nor(x),1,mu);
end
disp('finished mu-law companding');
disp('start to quantization')
bits = input('input bits=>');
% midtread quantization and encoding 
for x=1:lg
   [indx(x) qy] = mtrdenc(bits, 1, ymu(x));
end
disp('finished and transmitted');
% 
% midtread decoding
for x=1:lg
   qymu(x) = mtrddec(bits, 1, indx(x));
end
disp('expander');
for x=1:lg
  dymu(x)= muexpand(qymu(x),1,mu)*5;
 end
disp('finished')
qerr = dymu-we;   % quantization error
subplot(3,1,1);plot(we);grid
ylabel('Speech');axis([0 lg -5 5]);
subplot(3,1,2);plot(dymu);grid
ylabel('Recovered speech');axis([0 lg -5 5]);
subplot(3,1,3);plot(qerr);grid
ylabel('Quantized error');xlabel('Sample number');
axis([0 lg -1 1]);
snr(we,dymu);                 % calculate signal to noise ratio due to quantization
