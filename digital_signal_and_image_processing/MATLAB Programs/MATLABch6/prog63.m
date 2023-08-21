% MATLAB Program 6.3
% MATLAB program for Figures 6.30 and 6.31.
close all;clear all
fs=8000;                                                 % sampling rate
alpha =0.9;                                              % degree of pre-emphasis
figure(1);
freqz([1 -alpha],1,512,fs);                          % calculate and display frequency response
load speech.dat
figure(2);
y=filter([1 -alpha],1,speech);                    % filtering speech
subplot(2,1,1),plot(speech);grid;
ylabel('Speech samples')
title('Speech: We lost the golden chain.')
subplot(2,1,2),plot(y);grid
ylabel('Filtered samples')
xlabel('Number of samples');
title('Preemphasized speech.')
figure(3);
N=length(speech);                                           % length of speech
Axk=abs(fft(speech.*hamming(N)'))/N;        % two-side spectrum of speech
Ayk=abs(fft(y.*hamming(N)'))/N;       % two-side spectrum of preemphasized speech
f=[0:N/2]*fs/N;
Axk(2:N)=2*Axk(2:N);                       % get one-side spectrum of speech
Ayk(2:N)=2*Ayk(2:N);                       % get one-side spectrum of filtered speech
subplot(2,1,1),plot(f,Axk(1:N/2+1));grid
ylabel('Amplitude spectrum Ak')
title('Original speech');
subplot(2,1,2),plot(f,Ayk(1:N/2+1));grid
ylabel('Amplitude spectrum Ak')
xlabel('Frequency (Hz)');
title('Preemphasized speech');
%
