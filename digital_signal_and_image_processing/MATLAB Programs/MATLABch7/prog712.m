%MATLAB Program 7.12 for Example 7.18
%Sample MATLAB code
close all;clear all;clc;
sample =1:1:10;                                         %input test array
 x=[ 0 0 0];                                                %input buffer [x(n) x(n-1) ...]
 y=[0]; %output buffer [y(n) y(n-1) ... ]
 b=[1.0 1.2 0.36];                                      %FIR filter coefficients [b0 b1 ...]
 KK=length(b);
 for n=1:1:length(sample)                           % loop processing
     for k=KK:-1:2                                         % shift input by one sample
         x(k)=x(k-1);
     end
     x(1)=sample(n);                                    % get new sample
     y(1)=0;                                                  % perform FIR filtering
     for k=1:1:KK
         y(1)=y(1)+b(k)*x(k);
     end
     out(n)=y(1);  %send filtered sample to the output array
 end
out