%MATLAB Program 8.10 for Example 8.14
% Design of the 4th order digital lowpass Butterworth filter 
% in the cascade form
format long
fs=8000;                            % sampling rate
[B1 A1]=lp2lp([1],[1 0.7654 1], 2.3946*10^4) % complete step 2
[b1 a1]=bilinear(B1,A1,fs) % complete step 3
[B2 A2]=lp2lp([1],[1 1.8478 1], 2.3946*10^4) % complete step 2
[b2 a2]=bilinear(B2,A2,fs) % complete step 3
% plot the magnitude and phase responses |H(z)|
 % b1=[0.5108 1.0215 0.5108]; a1=[1 0.5654 0.4776]; coefficients from MATLAB
 % b2=[0.3730 0.7460 0.3730];  a2=[1 0.4129 0.0790]; coefficients from MATLAB
  freqz(conv(b1,b2),conv(a1,a2),512,fs);  % combined filter responses
  axis([0 fs/2 -40 10]);
