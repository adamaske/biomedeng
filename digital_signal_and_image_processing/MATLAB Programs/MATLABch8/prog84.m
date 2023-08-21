%MATLAB Program 8.4 for Example 8.8
% Design of the digital highpass Butterworth filter
  format long
  fs=8000;       % sampling rate
  [B A]=lp2hp([1.9652],[1  1.9652], 3.8627*10^4) % complete step 2
  [b a]=bilinear(B,A,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
% b=[0.4487 -0.4487 ]; numerator coefficients from MATLAB
% a=[1 0.1025]; denominator coefficients from MATLAB
  freqz(b,a,512,fs);
  axis([0 fs/2 -40 2])
