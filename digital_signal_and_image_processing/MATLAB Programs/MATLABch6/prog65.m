% MATLAB Program 6.5 
% Application of notch filtering to enhance ECG data
close all;clear all;
fs=500;                  % sampling rate
freqz([1 -1.4579 1],[1 -1.3850 0.9025],1000,fs);
axis([0 fs/2 -60 1]);                % frequency response of bandpass filter
figure
load ecg.dat; x=ecg;
t=[0:length(ecg)-1]/500;
x=x+1000*cos(2*pi*60*t)
y=filter([1 -1.4579 1],[1 -1.3850 0.9025],x);
subplot(2,1,1),plot(x,'k'); grid;                     % filtering speech
ylabel('Origibal Samples')
title('Raw ECG corrupted by 60 Hz interference.')
subplot(2,1,2),plot(y,'k');grid
xlabel('Number of Samples');ylabel('Filtered Samples')
title('Enhanced ECG signal.')
figure
N=length(x);
Axk=abs(fft(x.*hamming(N)'))/N;  % one-side spectrum of speech
Ayk=abs(fft(y.*hamming(N)'))/N;           % on-side spectrum of filtered speech
f=[0:N/2]*fs/N; 
Axk(2:N)=2*Axk(2:N);Ayk(2:N)=2*Ayk(2:N);  % one-side spectra
subplot(2,1,1),plot(f,Axk(1:N/2+1),'k');grid
ylabel('Amplitude spectrum Ak')
title('Raw ECG corrupted by 60 Hz interference.');
subplot(2,1,2),plot(f,Ayk(1:N/2+1),'k');grid
ylabel('Amplitude spectrum Ak');xlabel('Frequency (Hz)');
title('Enhanced ECG signal');
