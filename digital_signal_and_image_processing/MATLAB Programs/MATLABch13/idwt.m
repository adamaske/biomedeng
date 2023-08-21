function c = idwt(h0,w,kLevel)
% c = idwt(h0,w,kLevel)
%  Computes the inverse fast wavelet transform from data W using the
%  orthonormal wavelets defined by the coefficients.
%  h0 = wavelet filter coefficients
%  w = wavelet coefficients
%  kLevel = level
%  c = IDWT coefficients
n=length(w); m = length(h0);
h1 = h0(m:-1:1); h1(2:2:m)=-h1(2:2:m);
h0 = h0(:); h1 = h1(:);
w = w(:); c = w;
x = zeros(n+m-2,1);
% Perform the reconstruction through k levels
% x = periodized version of x-coefficients (circular convolution)
n = n/2^kLevel;
for i = 1:kLevel
    x(1:2*n+m-2) = zeros(2*n+m-2,1);
    for j = 1:n
	x(1+2*(j-1):m+2*(j-1)) = x(1+2*(j-1):m+2*(j-1)) + c(j)*h0 + w(n+j)*h1;
    end
    for i = 2*n+m-2:-1:2*n+1
	x(i-2*n) = x(i-2*n) + x(i);
    end
    c(1:2*n) = x(1:2*n);
    n = 2 * n;
end
