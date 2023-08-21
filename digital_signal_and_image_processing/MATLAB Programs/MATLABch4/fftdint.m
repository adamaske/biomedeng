function Xk = fftdint(x)
% FFT using decimation-in-time method, no need for bit reversal algorithm
% DSP Li Tan & Jean Jiang, March 6, 2016
  M=ceil(log2(length(x)));
  x=[x zeros(1,2^M-length(x))]; %paddig zeros to have a length of power of 2
  N=length(x);
  if (N==1)
      Xk=x;
  else 
  G=fftdint(x(1:2:N));
  H=fftdint(x(2:2:N)).*exp(-2*pi*j*[0:1:N/2-1]/N);
  Xk=[G+H G-H];
  end
end
