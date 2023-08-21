% MATLAB Program 6.4 
% Application of bandpass filtering
fs=8000;                  % sampling rate
freqz([0.0201 0.00 -0.0402 0 0.0201],[1 -2.1192 2.6952 -1.6924 0.6414],512,fs);
axis([0 fs/2 -40 1]);                % frequency response of bandpass filter
figure
load speech.dat
y=filter([0.0201 0.00 -0.0402 0.0201],[1 -2.1192 2.6952 -1.6924 0.6414],speech);
subplot(2,1,1),plot(speech); grid;                     % filtering speech
ylabel('Origibal Samples')
title('Speech: We lost the golden chain.')
subplot(2,1,2),plot(y);grid
xlabel('Number of Samples');ylabel('Filtered Samples')
title('Bandpass filtered speech.')
figure
N=length(speech);
Axk=abs(fft(speech.*hamming(N)'))/N;  % one-side spectrum of speech
Ayk=abs(fft(y.*hamming(N)'))/N;           % on-side spectrum of filtered speech
f=[0:N/2]*fs/N; 
Axk(2:N)=2*Axk(2:N);Ayk(2:N)=2*Ayk(2:N);  % one-side spectra
subplot(2,1,1),plot(f,Axk(1:N/2+1));grid
ylabel('Amplitude spectrum Ak')
title('Original speech');
subplot(2,1,2),plot(f,Ayk(1:N/2+1));grid
ylabel('Amplitude spectrum Ak');xlabel('Frequency (Hz)');
title('Bandpass filtered speech');
