function w = dwt(h0,c,kLevel)
% w = dwt(h,c,k)
%  Computes wavelet transform coefficnets for a vector c using the
%  orthonormal wavelets defined by the coefficients h
%  h = wavelet coefficients
%  c =input vetor
%  kLelvel= level
%  w = wavelet coefficients
n=length(c);
m = length(h0);
h1 = h0(m:-1:1);
h1(2:2:m)=-h1(2:2:m);
h0 = h0(:)'; h1 = h1(:)';
c = c(:);
w = c;
x = zeros(n+m-2,1);
% Perform decomposition through k levels
% at each step, x = periodized version of x-coefficients
for j = 1:kLevel
    x(1:n) = w(1:n);
    for i = 1:m-2
	x(n+i) = x(i);
    end
    for i = 1:n/2
	w(i)       = h0 * x(1 + 2*(i-1):m + 2*(i-1));
	w(n/2 + i) = h1* x(1 + 2*(i-1):m + 2*(i-1));
    end
    n = n/2;
end

