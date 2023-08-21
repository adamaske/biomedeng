%MATLAB Program 8.6 for Example 8.10
% Design of the digital lowpass Chebyshev filter
  format long
fs=8000;                % sampling rate
% BLT design
  [B A]=lp2hp([1.4314],[1 1.4256 1.5162], 3.8627*10^4) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
% b=[0.1327 -0.2654 0.1327]; numerator coefficients from MATLAB
% a=[1 0.7996 0.3618]; denominator coefficients from MATLAB
  freqz(b,a,512,fs);
  axis([0 fs/2 -40 10])
