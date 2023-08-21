% MATLAB Porgram 7.9 for Example 7.14
% MATLAB program to create Figure 7.30
close all; clear all;
fs=8000;
H1=[0 0 0 0 1 1 1 1 1 0  0 0 0];                    % magnitude specifications
B1=firfs(25,H1);                                          % design filter
[h1,f]=freqz(B1,1,512,fs);                              % calculate magnitude frequency response
H2=[0 0 0 0.5 1 1 1 1 1 0.5 0 0 0];              % magnitude spectrum
B2=firfs(25,H2);                                          % design filter
[h2,f]=freqz(B2,1,512,fs);                              % calculate magnitude frequency response     
p1=180*unwrap(angle(h1)')/pi;
p2=180*unwrap(angle(h2)')/pi
subplot(2,1,1); plot(f,20*log10(abs(h1)),'-.',f,20*log10(abs(h2)));grid
axis([0 fs/2 -100 10]);
xlabel('Frequency (Hz)'); ylabel('Magnitude Response (dB)');
subplot(2,1,2); plot(f,p1,'-.',f,p2);grid
xlabel('Frequency (Hz)'); ylabel('Phase (degrees)');
