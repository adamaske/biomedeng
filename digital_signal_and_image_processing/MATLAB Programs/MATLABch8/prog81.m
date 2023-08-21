%MATLAB Program 8.1 in Example 8.2
W=0:1:200;    %analog frequency points for computing the filter gains
Ha=freqs([1 0],[1 40],W);                         % frequency response for the highpass filter
Hb=freqs([20 0],[1 20 100],W);                % frequency response for the bandpass filter
subplot(2,1,1);plot(W, abs(Ha),'k');grid     % the filter gain plot for highpass filter 
xlabel('(a) Frequency (radians per second)')
ylabel('Absolute filter gain');
subplot(2,1,2);plot(W,abs(Hb),'k');grid     % the filter gain plot for bandpass filter 
xlabel('(b) Frequency (radians per second)')
ylabel('Absolute filter gain');