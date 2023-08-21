%MATLAB Program 2.2
%MATLAB progran for Example 2.14
clear all; close all
disp('load speech: We');
load we.dat % load speech data at the current folder
sig = we;                           % provided by the instructor
fs=8000;                            % sampling rate
lg=length(sig);                     % length of signal vector
T=1/fs;                             % sampling period
t=[0:1:lg-1]*T;              %  time instants in second  
sig=4.5*sig/max(abs(sig));   % normalizes speech in the range from -4.5 to 4.5
Xmax = max(abs(sig));                          % maximum amplitude
Xrms = sqrt( sum(sig .* sig) / length(sig))    % RMS value 
disp('Xrms/Xmax')
k=Xrms/Xmax
disp('20*log10(k)=>');
k = 20*log10(k)
bits = input('input number of bits =>');
lg = length(sig);
for x=1:lg
  [Index(x) pq] = biquant(bits, -5,5, sig(x));	%output quantized index.
end
% transmitted
% received
for x=1:lg
  qsig(x) = biqtdec(bits, -5,5, Index(x));		%recover the quantized value
end
  qerr = sig-qsig;				%calculate the quantized error
subplot(3,1,1);plot(t,sig);
ylabel('Original speech');title('we.dat: "we"');
subplot(3,1,2);stairs(t, qsig);grid
ylabel('Quantized speech')
subplot(3,1,3);stairs(t, qerr);grid
ylabel('Quantized error')
xlabel('Time (sec.)');axis([0 0.25 -1 1]);
disp('signal to noise ratio due to quantization noise')
snr(sig,qsig);        % signal to ratio in dB: sig = original signal vector,
                      % qsig =quantized signal vecter
