% MATLAB Program 7.10 for Example 7.15
% MATLAB program to create Figure 7.32
close all;clear all;
fs=8000;
f=[ 0 0.2 0.25 1]; % edge frequencies
m=[ 1  1    0  0] ; % ideal magnitudes
w=[   1  12 ];  % error weight factors
b=remez(53,f,m,w);    % (53+1)Parks-McClellen algorithm and Remez exchange
format long
freqz(b,1,512,fs) % plot the frequency response
axis([0 fs/2 -80 10]);
