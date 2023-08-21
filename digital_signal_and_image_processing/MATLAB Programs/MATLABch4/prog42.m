%MATLAB Program 4.2
%Example 4.11
close all;clear all;clc
% generate the sine wave sequence
fs=8000; T=1/fs;                      % Sampling rate and sampling period
x=2*sin(2000*pi*[0:1:50]*T); %generate 51 2000-Hz samples.
% apply the FFT algorithm
N=length(x);
  index_t=[0:1:N-1];
f=[0:1:N-1]*8000/N;		%Map frequency bin to frequency (Hz)
xf=abs(fft(x))/N;		%Calculate amplitude spectrum
figure(1)
%using Bartlett window
x_b=x.*bartlett(N)';		%Apply triangular window function
xf_b=abs(fft(x_b))/N;	%Calculate amplitude spectrum
subplot(2,2,1);plot(index_t,x);grid
xlabel('Time index n'); ylabel('x(n)');
subplot(2,2,3); plot(index_t,x_b);grid
xlabel('Time index n'); ylabel('Triangular windowed x(n)');
  subplot(2,2,2);plot(f,xf);grid;axis([0 8000 0 1]);
xlabel('Frequency (Hz)'); ylabel('Ak (no window)');
subplot(2,2,4); plot(f,xf_b);grid; axis([0 8000 0 1]);
xlabel('Frequency (Hz)'); ylabel('Triangular windowed Ak');
figure(2)
% generate the sine wave sequence
x=2*sin(2000*pi*[0:1:100]*T);    %generate 101 2000-Hz samples.
% apply the FFT algorithm
N=length(x);
index_t=[0:1:N-1];
f=[0:1:N-1]*fs/N;
xf=abs(fft(x))/N;
%using Hamming window
x_hm=x.*hamming(N)';		%Apply Hamming window function
xf_hm=abs(fft(x_hm))/N;		%Calculate amplitude spectrum
subplot(2,2,1);plot(index_t,x);grid
xlabel('Time index n'); ylabel('x(n)');
subplot(2,2,3); plot(index_t,x_hm);grid
xlabel('Time index n'); ylabel('Hamming windowed x(n)');
subplot(2,2,2);plot(f,xf);grid;axis([0 fs 0 1]);
xlabel('Frequency (Hz)'); ylabel('Ak (no window)');
subplot(2,2,4); plot(f,xf_hm);grid;axis([0 fs 0 1]);
xlabel('Frequency (Hz)'); ylabel('Hamming windowed Ak');
figure(3)
% generate the sine wave sequence
x=2*sin(2000*pi*[0:1:150]*T);   % generate 151 2-kHz samples
% apply the FFT algorithm
N=length(x);
index_t=[0:1:N-1];
f=[0:1:N-1]*fs/N;
xf=2*abs(fft(x))/N;xf(1)=xf(1)/2;    % single-sided spectrum
%using Hanning window
x_hn=x.*hann(N)';
xf_hn=2*abs(fft(x_hn))/N;xf_hn(1)=xf_hn(1)/2;   %single-sided spectrum
subplot(2,2,1);plot(index_t,x);grid
xlabel('Time index n'); ylabel('x(n)');
subplot(2,2,3); plot(index_t,x_hn);grid
xlabel('Time index n'); ylabel('Hanning windowed x(n)');
subplot(2,2,2);plot(f(1:(N-1)/2),xf(1:(N-1)/2));grid;axis([0 fs/2 0 2]);
xlabel('Frequency (Hz)'); ylabel('Ak (no window)');
subplot(2,2,4); plot(f(1:(N-1)/2),xf_hn(1:(N-1)/2));grid;axis([0 fs/2 0 2]);
xlabel('Frequency (Hz)'); ylabel('Hanning windowed Ak');
