  function [ tdac_coef ] = wmdct(ipsig)
% 
% This function transforms the signal vector using the W-MDCT
  % usage:
  % ipsig: inpput signal block of N samples (N=even number)
  % tdac_coe: W-MDCT coefficents (N/2 coefficients)
  %
  N = length(ipsig);
  NN =N;
  for i=1:NN
    h(i) = sin((pi/NN)*(i-1+0.5));
  end
  for k=1:N/2
    tdac_coef(k) = 0.0;
    for n=1:N
      tdac_coef(k) = tdac_coef(k) + ...
      h(n)*ipsig(n)*cos((2*pi/N)*(k-1+0.5)*(n-1+0.5+N/4));
    end
  end
  tdac_coef=2*tdac_coef;
