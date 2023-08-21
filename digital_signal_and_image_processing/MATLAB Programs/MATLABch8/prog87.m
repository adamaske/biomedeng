%MATLAB Program 8.7 for Example 8.11
% Design of the digital bandpass Butterworth filter
  format long
  fs=8000;
  [B A]=lp2bp([1],[1 1],sqrt(5.7499*10^8),4088) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
 % b=[0.0730 0 -0.0730]; numerator coefficients from MATLAB
 % a=[1 0.7117 0.8541]; denominator coefficients form MATLAB
  freqz(b, a,512,fs);
  axis([0 fs/2 -40 10])
