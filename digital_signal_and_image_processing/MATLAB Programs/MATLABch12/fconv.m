function [y] = fconv(h,c)
% Circuilar onvolution using the forward filter coefficients h(k)
% h = filter coefficnets
% c = input vector
% y = output vector
N=length(c); M=length(h);
x(1:N+M-1) = zeros(1,N+M-1);
    for j = 1:N
	x(j:M+(j-1)) = x(j:M+(j-1)) + c(j)*h;
    end
    for i = N+M-1:-1:N+1
	x(i-N) = x(i-N) + x(i); % circular convolution
    end
    y=x(1:N);


