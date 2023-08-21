function [g] = qmf(h);

% [G] = qmf(H)
%  Given the impulse response coefficients H, QMF(H) returns
%  the impulse response coefficients of the conjugate mirror filter.
%  H must have an even number of coefficients.
M2= length(h);

if floor(M2/2)~=M2/2,
  error('QMF: FIR filter must be even order.');
end

g(1:2:M2-1) = h(M2:-2:2);
g(2:2:M2) = -h(M2-1:-2:1);
