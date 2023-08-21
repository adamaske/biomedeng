% MATLAB Program for calculating and displaying speech spectrum
% Section 4.4
close all; clear all;clc
load we.dat
x=we;
fs=8000;                 %sampling rate
% apply the FFT algorithm
N=length(x);             % number of samples
index_t=[0:1:N-1];       % time index
f=[0:1:N-1]*fs/N;        % mape frequency index to frequency in Hz
xf=abs(fft(x))/N;        % compute amplitude spectrum 
figure(1)
%using Bartlett window
N
length(x)
x_b=x.*bartlett(N)';     % use Barlett window
xf_b=abs(fft(x_b))/N;    % compute amplitude spectrum

subplot(2,2,1);plot(index_t,x);grid
ylabel('x(n)');
xlabel('Time index n');
subplot(2,2,3); plot(index_t,x_b);grid;
xlabel('Time index n');
ylabel('Triangular windowed x(n)');

subplot(2,2,2);plot(f,xf);grid;axis([0 fs 0 400]);
xlabel('Frequency (Hz)');
ylabel('Amplitude spectrum Ak');
subplot(2,2,4); plot(f,xf_b);grid;axis([0 fs 0 400]);
xlabel('Frequency (Hz)');
ylabel('Triangular windowed Ak');

figure(2)
%using Hamming window
N
length(x)
x_hm=x.*hamming(N)';                 % use Hamming window
xf_hm=2*abs(fft(x_hm))/N;xf_hm(1)=xf_hm(1)/2;% compute amplitude spectrum

subplot(2,2,1);plot(index_t,x);grid
xlabel('Time index n');
ylabel('x(n)');
subplot(2,2,3); plot(index_t,x_hm);grid
xlabel('Time index n');
ylabel('Hamming windowed x(n)');

xxf=xf;xxf(2:N)=2*xf(2:N);
subplot(2,2,2);plot(f(1:N/2),xxf(1:N/2));grid;
xlabel('Frequency (Hz)');
ylabel('Amplitude spectrum Ak');axis([0 fs/2 0 800]);
subplot(2,2,4); plot(f(1:N/2),xf_hm(1:N/2));grid;
xlabel('Frequency (Hz)');
ylabel('Hamming windowed Ak');axis([0 fs/2 0 800]);

figure(3)
%using Hanning window
N
length(x)
x_hn=x.*hann(N)';              % use Hanning window
xf_hn=abs(fft(x_hn))/N;           % compute amplitude spectrum

subplot(2,2,1);plot(index_t,x);grid
xlabel('Time index n');
ylabel('x(n)');
subplot(2,2,3); plot(index_t,x_hn);grid
xlabel('Time index n');
ylabel('Hanning windowed x(n)');

subplot(2,2,2);plot(f,xf);grid;axis([0 fs 0 400]);
xlabel('Frequency (Hz)');
ylabel('Amplitude spectrum Ak');
subplot(2,2,4); plot(f,xf_hn);grid;
xlabel('Frequency (Hz)');
ylabel('Hanning windowed Ak');axis([0 fs 0 400]);

figure(4)
%using Hamming window
N
length(x)
x_hm=x.*hamming(N)';        % use Hamming window
xf_hm=abs(fft(x_hm))/N;     % compute amplitude spectrum

subplot(2,2,1);plot(index_t,x);grid
xlabel('Time index n');
ylabel('x(n)');
subplot(2,2,3); plot(index_t,x_hm);grid
xlabel('Time index n');
ylabel('Hamming windowed x(n)');

xxf=xf;
subplot(2,2,2);plot(f,xxf);grid;
xlabel('Frequency (Hz)');
ylabel('Amplitude spectrum Ak');axis([0 fs 0 400]);
subplot(2,2,4); plot(f,xf_hm);grid;
xlabel('Frequency (Hz)');
ylabel('Hamming windowed Ak');axis([0 fs 0 400]);

