%MATLAB Program 9.1b for Section 10.3.1
close all; clear all
load wen.dat                                            % given by the instructor
fs=8000;                                                  % sampling rate
t=0:1:length(wen)-1;                               % create index array                       
t=t/fs;                                                      % convert indices to time instant
x=randn(1,length(wen));                         % generate random noise
n=filter([ 0 0 0 0 0 0.5 ],1,x);                 %  generate the corruption noise 
d=wen+n;                                                % generate signal plus noise
w=zeros(1,21);                                        % initialize adaptive filter coefficients
y=zeros(1,length(t));                               % initialize the adaptive filter output array
e=y;                                                             % initialize the output array
Q=eye(21)*mean(sum(x.*x)); % Initialize the inverse of auto-correlation matrix
 % Adaptive filtering using the RLS algorithm
lamda=0.995;
% Perform adaptive filtering using the RLS algorithm
for n=21:length(t)
    xx=x(n:-1:n-20)';   % Obtain input vector
    alpha=d(n)-w*xx;
    k=Q*xx/(lamda+xx'*Q*xx);
    w=w+k'*alpha;
    Q=(Q-k*xx'*Q)/lamda;
    y(n)=w*xx;
    e(n)=d(n)-y(n);
end

% calculate single-side amplitude spectrum for the original signal
 WEN=2*abs(fft(wen))/length(wen);WEN(1)=WEN(1)/2;
% calculate single-side amplitude spectrum for the corrupted signal
 D=2*abs(fft(d))/length(d);D(1)=D(1)/2;
 f=[0:1:length(wen)/2]*fs/length(wen);
% calculate single-side amplitude spectrum for the noise cancelled signal
 E=2*abs(fft(e))/length(e);E(1)=E(1)/2;
% plot signals and spectrums
 subplot(4,1,1), plot(wen);grid; ylabel('Orig. speech');
 subplot(4,1,2),plot(d);grid; ylabel('Corrupt. speech')
 subplot(4,1,3),plot(x);grid;ylabel('Ref. noise');
 subplot(4,1,4),plot(e);grid; ylabel('Clean speech');
 xlabel('Number of samples');
 figure
subplot(3,1,1),plot(f,WEN(1:length(f)));grid
 ylabel('Orig. spectrum')
subplot(3,1,2),plot(f,D(1:length(f)));grid; ylabel('Corrupt. spectrum')
subplot(3,1,3),plot(f,E(1:length(f)));grid
 ylabel('Clean spectrum'); xlabel('Frequency (Hz)');
