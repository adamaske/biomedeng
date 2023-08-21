%MATLAB Program 8.15 for Example 8.22
%Sample MATLAB code
sample =2:2:20;  % input test array
 x=[0];                                        %input buffer [x(n) ]
 y=[0];                                        %output buffer [y(n)]
 w=[0 0 0]; % buffer for w(n) [w(n) w(n-1) ...]
 b=[0.7157 1.4314 0.7157];        % numerator coefficients [b0 b1 ...]
 a=[1 1.3490 0.5140]; % denominator coefficients [1 a1 a2 ...]
 for n=1:1:length(sample)          % processing loop
     for k=3:-1:2
         w(k)=w(k-1);                     %shift w(n) by one sample
     end
     x(1)=sample(n);                     % get new sample
     w(1)=x(1);                             % perform IIR filtering
     for k=2:1:3
         w(1)=w(1)-a(k)*w(k);
     end
     y(1)=0;                                   % perform FIR filtering
     for k=1:1:3
         y(1)=y(1)+b(k)*w(k);
     end
     out(n)=y(1);                           % send the filtered sample to output array
 end
     out
