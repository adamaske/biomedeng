%MATLAB Program 8.20 for DTMF tone detection in Section 8.11.3
close all;clear all;
% DTMF tone generator
N=205;
fs=8000; t=[0:1:N-1]/fs;                            % sampling rate and time vector
x=zeros(1,length(t));x(1)=1;                     % generate imupse function
%generation of tones
y697=filter([0 sin(2*pi*697/fs)],[1 -2*cos(2*pi*697/fs) 1],x); 
y770=filter([0 sin(2*pi*770/fs)],[1 -2*cos(2*pi*770/fs) 1],x); 
y852=filter([0 sin(2*pi*852/fs)],[1 -2*cos(2*pi*852/fs) 1],x);   
y941=filter([0 sin(2*pi*941/fs)],[1 -2*cos(2*pi*941/fs) 1],x); 
y1209=filter([0 sin(2*pi*1209/fs) ],[1 -2*cos(2*pi*1209/fs) 1],x); 
y1336=filter([0 sin(2*pi*1336/fs)],[1 -2*cos(2*pi*1336/fs) 1],x); 
y1477=filter([0 sin(2*pi*1477/fs)],[1 -2*cos(2*pi*1477/fs) 1],x); 
key=input('input of the following keys: 1,2,3,4,5,6,7,8,9,*,0,# =>','s');
yDTMF=[];
if key=='1' yDTMF=y697+y1209; end
if key=='2' yDTMF=y697+y1336; end
if key=='3' yDTMF=y697+y1477; end
if key=='4' yDTMF=y770+y1209; end
if key=='5' yDTMF=y770+y1336; end
if key=='6' yDTMF=y770+y1477; end
if key=='7' yDTMF=y852+y1209; end
if key=='8' yDTMF=y852+y1336; end
if key=='9' yDTMF=y852+y1477; end
if key=='*' yDTMF=y941+y1209; end
if key=='0' yDTMF=y941+y1336; end
if key=='#' yDTMF=y941+y1477; end
if size(yDTMF)==0 disp('Invalid input key'); return; end
sound(yDTMF,8000); pause;
yDTMF=[yDTMF 0];                % DTMF signal appened with a zero
% DTMF detector (use Goertzel algorithm)
a697=[1 -2*cos(2*pi*18/N) 1];
a770=[1 -2*cos(2*pi*20/N) 1];
a852=[1 -2*cos(2*pi*22/N) 1];
a941=[1 -2*cos(2*pi*24/N) 1];
a1209=[1 -2*cos(2*pi*31/N) 1];
a1336=[1 -2*cos(2*pi*34/N) 1];
a1477=[1 -2*cos(2*pi*38/N) 1];
% filter bank frequency responses
[w1, f]=freqz(1,a697,512,fs);
[w2, f]=freqz(1,a770,512,fs);
[w3, f]=freqz(1,a852,512,fs);
[w4, f]=freqz(1,a941,512,fs);
[w5, f]=freqz(1,a1209,512,fs);
[w6, f]=freqz(1,a1336,512,fs);
[w7, f]=freqz(1,a1477,512,fs);
subplot(2,1,1);plot(f,abs(w1),f,abs(w2),f,abs(w3), ...
 f,abs(w4),f,abs(w5),f,abs(w6),f,abs(w7));grid
xlabel('Frequency (Hz)'); ylabel('(a) Filter bank freq. responses');

% filter bank bandpass filtering 
y697=filter(1,a697,yDTMF);
y770=filter(1,a770,yDTMF);
y852=filter(1,a852,yDTMF);
y941=filter(1,a941,yDTMF);
y1209=filter(1,a1209,yDTMF);
y1336=filter(1,a1336,yDTMF);
y1477=filter(1,a1477,yDTMF);
% determine the absolute magnitude of DFT coefficents
m(1)=sqrt(y697(206)^2+y697(205)^2- ...
     2*cos(2*pi*18/205)*y697(206)*y697(205));
m(2)=sqrt(y770(206)^2+y770(205)^2- ...
     2*cos(2*pi*20/205)*y770(206)*y770(205));
m(3)=sqrt(y852(206)^2+y852(205)^2- ...
     2*cos(2*pi*22/205)*y852(206)*y852(205));
m(4)=sqrt(y941(206)^2+y941(205)^2- ...
     2*cos(2*pi*24/205)*y941(206)*y941(205));
m(5)=sqrt(y1209(206)^2+y1209(205)^2- ...
     2*cos(2*pi*31/205)*y1209(206)*y1209(205));
m(6)=sqrt(y1336(206)^2+y1336(205)^2- ...
     2*cos(2*pi*34/205)*y1336(206)*y1336(205));
m(7)=sqrt(y1477(206)^2+y1477(205)^2- ...
     2*cos(2*pi*38/205)*y1477(206)*y1477(205));
% convert the magnitude of DFT coefficients to the single-side spectrum
m=2*m/205;   
% determine the threshold 
th=sum(m)/4;  
% plot DTMF spectrum with the threshold
f=[ 697 770 852 941 1209 1336 1477];
f1=[0  fs/2];
th=[ th th];
subplot(2,1,2);stem(f,m);grid;hold; plot(f1,th);
xlabel('Frequency (Hz)'); ylabel(' (b) Spectral values');
m=round(m); % round to binary pattern
if m== [ 1 0 0 0 1 0 0]  disp('Detected Key 1'); end
if m== [ 1 0 0 0 0 1 0]  disp('Detected Key 2'); end
if m== [ 1 0 0 0 0 0 1]  disp('Detected Key 3'); end
if m== [ 0 1 0 0 1 0 0]  disp('Detected Key 4'); end
if m== [ 0 1 0 0 0 1 0]  disp('Detected Key 5'); end
if m== [ 0 1 0 0 0 0 1]  disp('Detected Key 6'); end
if m== [ 0 0 1 0 1 0 0]  disp('Detected Key 7'); end
if m== [ 0 0 1 0 0 1 0]  disp('Detected Key 8'); end
if m== [ 0 0 1 0 0 0 1]  disp('Detected Key 9'); end
if m== [ 0 0 0 1 1 0 0]  disp('Detected Key *'); end
if m== [ 0 0 0 1 0 1 0]  disp('Detected Key 0'); end
if m== [ 0 0 0 1 0 0 1]  disp('Detected Key #'); end