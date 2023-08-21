function [ opsig ] = wimdct(tdac_coef)
%
% This function transform the W-MDCT coefficients back to the signal
  % usage:
  % tdac_coeff: N/2 W-MDCT coeffcients
  % opsig: output signal black with N samples
  %
  N = length(tdac_coef);
  tmp_coef = ((-1)^(N+1))*tdac_coef(N:-1:1);
  tdac_coef = [ tdac_coef tmp_coef];
  N = length(tdac_coef);
   NN =N;
  for i=1:NN
    f(i) = sin((pi/NN)*(i-1+0.5));
  end
  for n=1:N
    opsig(n) = 0.0;
    for k=1:N
      opsig(n) = opsig(n) + ...
      tdac_coef(k)*cos((2*pi/N)*(k-1+0.5)*(n-1+0.5+N/4));
    end
    opsig(n) = opsig(n)*f(n)/N;
  end
