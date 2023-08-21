% MATLAB Proogram for the digital crossover suystem in Section 7.4.3
clear all; close all
format long
fs=44100;
wc=2*pi*1000/fs;
BL=firwd(183,1,wc,0,4);
BH=firwd(183,2,0,wc,4);
[hL f]=freqz(BL,1,44100,fs);
[hH f]=freqz(BH,1,44100,fs);
hh=abs(hL)+abs(hH);
subplot(2,1,1);semilogx(f,20*log10(hL));grid
axis([1  45000 -200 20]);xlabel('Frequency (Hz)');ylabel('Magnitude response (dB)');
subplot(2,1,2);semilogx(f,20*log10(hH));grid
axis([1  45000 -200 20]);xlabel('Frequency (Hz)');ylabel('Magnitude response (dB)');
figure
semilogx(f,20*log10(hh),f,20*log10(hL),f,20*log10(hH));grid
axis([1  45000 -200 20]);xlabel('Frequency (Hz)');ylabel('Magnitude response (dB)');

figure
subplot(2,1,1);stem(BL);grid;xlabel('n');ylabel('Impulse response of LPF');
subplot(2,1,2);stem(BH);grid;xlabel('n');ylabel('Impulse response of HPF');