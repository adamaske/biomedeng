%MATLAB Program 8.3 for Example 8.7
% Design of the digital lowpass Butterworth filter
  format long
  fs=8000;                                         % sampling rate
  [B A]=lp2lp([1],[1  1], 1.0691*10^4) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
% b=[0.4005 0.4005];  numerator coefficients from MATLAB
% a=[1 -0.1989]; denominator coefficients from MATLAB
  freqz(b,a,512,fs);
  axis([0 fs/2 -20 1])
