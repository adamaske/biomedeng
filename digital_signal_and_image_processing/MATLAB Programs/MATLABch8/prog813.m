%MATLAB Program 8.13 for Example 8.16
% plot the magnitude responses |H(s)| and |H(z)|
% for the Laplace transfer function H(s)
  f=0:0.1:5;T=0.1;  % initialize analog frequency range in Hz and sampling interval
  w=2*pi*f;           % convert the frequency range to radians/second
  hs=freqs([1 0], [1 2 5],w); % calculate analog filter frequency responses
  phis=180*angle(hs)/pi;
  % for the z-transfer function H(z)
% calculate digital filter frequency responses
  hz=freqz([0.1 -0.09766],[1 -1.7735 0.8187],length(w));
phiz=180*angle(hz)/pi;
% plot magnitude and phase responses
  subplot(2,1,1), plot(f,abs(hs),'x',f, abs(hz),'-'),grid;
  xlabel('Frequency (Hz)'); ylabel('Magnitude Responses')
  subplot(2,1,2), plot(f,phis,'x',f, phiz,'-'); grid;
  xlabel('Frequency (Hz)'); ylabel('Phases (degrees)')