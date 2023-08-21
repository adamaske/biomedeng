%MATLAB program 8.2 for Example 8.6
% plot the magnitude and phase responses |H(z)|
fs=90;                        % sampling rate (Hz)
[B, A]=lp2lp([1],[1 1],103.92);
[b,a]=bilinear(B,A,fs)
%b= [0.3660 0.3660]    numerator coefficients from MATLAB
%a=  [1 -0.2679]  denominator coefficients of from MATLAB
  [hz, f]=freqz([0.3660 0.3660],[1 -0.2679],512,fs); %the frequency response
  phi=180*unwrap(angle(hz))/pi;
  subplot(2,1,1), plot(f, abs(hz)),grid;
  axis([0 fs/2 0 1]);
  xlabel('Frequency (Hz)'); ylabel('Magnitude Response')
  subplot(2,1,2), plot(f, phi); grid;
  axis([0 fs/2 -100 0]);
  xlabel('Frequency (Hz)'); ylabel('Phase (degrees)')
