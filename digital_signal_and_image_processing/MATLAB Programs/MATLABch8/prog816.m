% MATLAB Program 8.16 for ECG analysis in Section 8.9
load ecgbn.dat;  % load noisy ECG recording
b1=[0.9803 -1.5862 0.9803];   %Notch filter with a notch frequency of 60 Hz
a1=[1 -1.5842 0.9586];
b2=[0.9794 -0.6053 0.9794];   % notch filter with a notch frequency 120 Hz
a2=[1 -0.6051 0.9586];
b3=[0.9793 0.6052 0.9793];  % notch filter with a notch frequency of 180 Hz
a3=[1 0.6051 0.9586];
y1=filter(b1,a1,ecgbn);  % 1st section filtering
y2=filter(b2,a2,y1);        % second section filtering
y3=filter(b3,a3,y2);       % third section filtering
%bandpass filter
fs=600;                         % sampling rate
T=1/600;                       % sampling interval
% BLT design
wd1=2*pi*0.25;           
wd2=2*pi*40;
wa1=(2/T)*tan(wd1*T/2);
wa2=(2/T)*tan(wd2*T/2);
[B,A]=lp2bp([1.4314], [1 1.4652 1.5162],sqrt(wa1*wa2),wa2-wa1);
[b,a]=bilinear(B,A,fs);
%b =[0.046361 0 -0.092722 0 0.046361] numerator coefficients from MATLAB
%a =[1 -3.352292 4.255671 -2.453965 0.550587]denomibator coefficients 
y4=filter(b,a,y3);                                %bandpass filtering
t=0:T:1499*T;                                    % recover time
subplot(3,1,1);plot(t,ecgbn);grid;ylabel('(a)');
subplot(3,1,2);plot(t,y3);grid;ylabel('(b)');
subplot(3,1,3);plot(t,y4);grid;ylabel('(c)');
xlabel('Time (sec.)');
%zero cross algorithm
zcross=0.0;threshold=0.5
for n=2:length(y4)
    pre_sign=-1;cur_sign=-1;
   if y4(n-1)>threshold
       pre_sign=1;
   end
   if  y4(n)>threshold
      cur_sign=1;
   end
  zcross=zcross+abs(cur_sign-pre_sign)/2;
end
zcross                                 % output the number of zero crossing
rate=60*zcross/(2*length(y4)/600)       % output heart rate
