%MATLAB Program 8.14 for Example 8.21
%Sample MATLAB code
sample = 2:2:20; %input test array
 x=[ 0 0 ]; % input buffer [x(n) x(n-1) ...]
 y=[ 0 0];  % output buffer [y(n) y(n-1) ... ]
 b=[0.1936 -0.1936]; % numerator coefficients [b0 b1 ... ]
 a=[1 0.6128];  % denominator coefficients [1 a0 a1 ...]
 for n=1:1:length(sample) % processing loop
     for k=2:-1:2      
         x(k)=x(k-1);   % shift input by one sample
         y(k)=y(k-1);   % shift output by one sample
     end
     x(1)=sample(n);    % get new sample
     y(1)=0;            % digital filtering
     for k=1:1:2
         y(1)=y(1)+x(k)*b(k);
     end
     for k=2:2
         y(1)=y(1)-a(k)*y(k);
     end
     out(n)=y(1); %output the filtered sample to output array
 end
     out
