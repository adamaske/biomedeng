%MATLAB Program 8.8 for Example 8.12
% Design of the digital bandstop Butterworth filter
  format long
  fs=8000;                     % sampling rate
  [B A]=lp2bs([1],[1 1],sqrt(5.7341*10^8),4149) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
%  b=[0.9259 0.7078 0.9259]; numerator coefficients from MATLAB
% a=[1 0.7078 0.8518]; denominator coefficients from MATLAB
  freqz(b,a,512,fs);
  axis([0 fs/2 -40 10])
