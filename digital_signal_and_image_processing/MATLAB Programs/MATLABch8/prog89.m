%MATLAB Program 8.9 for Example 8.13
% Design of the digital bandpass Chebyshev filter
  format long
  fs=8000;
  [B A]=lp2bp([2.8628],[1 2.8628],sqrt(5.7341*10^8),4016) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
%  b=[0.1815 0.0 -0.1815]; numerator coefficients from MATLAB
 % a=[1 0.6264 0.6369]; denominator coefficients from MATLAB
  freqz(b,a,512,fs);
  axis([0 fs/2 -40 10])
