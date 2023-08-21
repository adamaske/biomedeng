%MATLAB Program 8.17 for Example 8.25
% plot the magnitude and phase responses |H(z)|
  fs=8000;                                            % sampling rate
  B=[0.7434 1.4868 0.7434];
  A=[1 1.5149 0.6346];
  [hz,f]=freqz(B,A,512,fs);       % calculate reponses without coefficient quantization
  phi=180*unwrap(angle(hz))/pi;
  Bq=[0.750 1.4834375 0.75000];
  Aq=[1 1.515625 0.640625];
  [hzq,f]=freqz(Bq,Aq,512,fs);  % calculate responses with coefficient quantization
  phiq=180*unwrap(angle(hzq))/pi;
  subplot(2,1,1), plot(f,20*log10(abs(hz)),f,20*log10(abs(hzq)), '-.');grid;
  axis([0 fs/2 -10 2])
  xlabel('Frequency (Hz)');
  ylabel('Magnitude Response (dB)'); 
  subplot(2,1,2), plot(f, phi, f, phiq,'-.'); grid;
  xlabel('Frequency (Hz)');
  ylabel('Phase (degrees)');
