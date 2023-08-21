%MATLAB Program 8.5 for Example 8.9
% Design of the digital lowpass Butterworth filter
  format long
  fs=8000;                          % sampling rate
  [B A]=lp2lp([1],[1 1.4142 1], 6.6645*10^4) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
 % b=[0.7157 1.4315 0.7157]; numerator coefficients from MATLAB
 %a=[1 1.3490 0.5140]; denominator coefficients from MATLAB
  freqz(b,a,512,fs);
  axis([0 fs/2 -40 10])
