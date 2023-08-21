function [h,g] = daubechies(N)

% [h,g] = daubechies(N)
%  Compute coefficients for Daubechies' family of wavelets. The
%  coefficients in the vector h determine the dilation equation
%
%     \phi(x) = \sqrt{2}\sum_{k=0}^{2N-1} h_{k+1} \phi(2x-k)
%
%  Coefficients in the vector g establish the wavelet \psi(x) in
%  terms of the scale function \phi(x)
%
%     \psi(x) = \sqrt{2}\sum_{k=0}^{2N-1} g_{k+1} \phi(2x-k)
%
%  where g_{k} = (-1)^{k-1}h_{2N-k+1}. h is a vector with of length
%  2N satisfying the constraints:
%
%     a) \sum h = sqrt(2)
%     b) \sum h_{k}h{k-2m} = \delta_{0m}
%     c) Regularity of \phi(x) prop. to N (see notes)
%
%  The algorithm is based on Daubechies' 1988 paper in
%  Communications on Pure and Applied Mathematics.

if round(N)~=N | (N<1),
  error('Order must be an integer >=1');
end

% Compute coefficients of polynomial P(y) of order N-1, store
% in vector pN is ascending order

p = 1;
pN = [p];
for j=1:N-1,
  p = (N+j-1)*p/j;
  pN = [pN,p];
end

% Now compute polynomial abs(Q(z))^2, z = exp(iw)

f = [-1 2 -1]/4; % (sin(w/2))^2
fc = f;
q2 = pN(1);
for k=1:N-1,
  q2 = [0,q2,0] + pN(k+1)*fc;
  fc = conv(fc,f); % form y^2
end

% q2 is a polynomial with coefficients in ascending order of
% powers ranging from 1-N to N-1. The coefficients of z^-k and
% z^k are the same. Roots are eigenvalues of a companion matrix.

r = eig([-q2(2:length(q2))./q2(1);eye(2*N-3),zeros(2*N-3,1)]);

% Construct q from the roots outside the unit disk
q = poly(r(find(abs(r)>1)));

% Normalize phase so that q(0) is real

q0 = q(length(q));
q = q*(conj(q0)/abs(q0));

% Everything should be real, so drop the imag parts

q = real(q);

% Now compute h by multiplying with (0.5(1+z))^N

for k = 1:N,
  q = conv(q,[1/2 1/2]);
end

% Normalize, since the normalization was lost in the factoring
% and reconstruction of q

h = sqrt(2)*q/sum(q);

% Report result in ascending order

h = h(length(h):-1:1);

% Compute the quadrature mirror filter from h

g = qmf(h);
