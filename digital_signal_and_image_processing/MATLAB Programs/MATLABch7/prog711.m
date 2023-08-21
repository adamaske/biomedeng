% MATLAB Program 7.11 for Example 7.16
% MATLAB program to create Figure 7.34
close all; clear all;
fs=8000;
f=[ 0 0.15 0.25  0.4  0.5 1];            % edge frequencies
m=[ 0   0   1    1    0  0];                 % ideal magnitudes
w=[  39 10 39 ];                             % error weight factors
format long
b=remez(25,f,m,w)     % (25+1) taps Parks-McClellen algorithm and Remez exchange
freqz(b,1,512,fs);        % plot the frequency response
axis([0 fs/2 -80 10])
