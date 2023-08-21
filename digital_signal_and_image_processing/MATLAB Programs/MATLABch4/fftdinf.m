function Xk= fftdinf(x)
% FFT using decimation-in-frequency method
% DSP Li Tan & Jean Jiang, March 6, 2016
    XX=fftdinf2(x);
    k=bitrev(1:1:length(XX));
    Xk=XX(k);
end
function Xk = fftdinf2(x)
% FFT using decimation-in-frequency method
% DSP Li Tan & Jean Jiang, March 6, 2016
  M=ceil(log2(length(x)));
  x=[x zeros(1,2^M-length(x))]; %paddig zeros to have a length of power of 2
  N=length(x);
  if (N==1)
      Xk=x;
  else
  a=x(1:N/2)+x(N/2+1:N);
  b=x(1:N/2)-x(N/2+1:N);
  Xk=[fftdinf2(a) fftdinf2(b.*exp(-2*pi*j*[0:1:N/2-1]/N))];
  end
end
function k = bitrev(x)
% bit reversal in terms of the integer
%  DSP Li Tan & Jean Jiang
%   x=1:1:2^M
    N=length(x);
   if N==1
      k=x;
   else
      k=[bitrev(x(1:2:N)) bitrev(x(2:2:N))];
      N=N/2;
   end
end
