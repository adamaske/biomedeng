function [y] = rconv(h,c)
% Circular onvolution using the reversed filter coefficients h(-k)
% h = filter coefficnets
% c = input vector
% y = output vector
N=length(c); M=length(h);
xx=zeros(1,M+N-1);
xx(1:N)=c;
xx(N+1:N+M-1)=c(1:M-1); % use periodized input 
for n=1:N;
    y(n)=0;
    for m=1:M
        y(n)=y(n)+h(m)*xx(n+m-1);
    end
end

