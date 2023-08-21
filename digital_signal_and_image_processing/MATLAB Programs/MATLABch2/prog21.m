% MATLAB Program 2.1
%Example 2.13
clear all; close all
disp('Generate 0.02-second sine wave of 100 Hz and Vp=5');
fs=8000;                                       % sampling rate
T=1/fs;                                        % sampling interval
t=0:T:0.02;                                    % duration of 0.02 second
sig = 4.5*sin(2*pi*100*t);                     %  generate sinusoids
bits = input('input number of bits =>');
lg = length(sig);                              % length of signal vector sig
for x=1:lg
  [Index(x)  pq] = biquant(bits, -5,5, sig(x)); % Output quantized index
end
% transmitted
% received
for x=1:lg
  qsig(x) = biqtdec(bits, -5,5, Index(x)); %Recover the quantized value the index 
end
  qerr = qsig-sig;		                   %Calculate quantized error
stairs(t,qsig); hold                       % plot signal in stair case style
plot(t,sig); grid;                         % plot signl
xlabel('Time (sec.)'); ylabel('Quantized x(n)')
disp('Signal to noise ratio due to quantization')
snr(sig,qsig);
