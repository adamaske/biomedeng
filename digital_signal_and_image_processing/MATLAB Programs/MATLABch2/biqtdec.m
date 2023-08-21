function pq = biqtdec(NoBits,Xmin,Xmax,I)
% function pq = biqtdec(NoBits,Xmin, Xmax, I)
% this routine recover the quantized value.
% 
%  NoBits: number of bits used in quantization.
%  Xmax: overload value
% Xmin: minimum value
%  pq: output of quantized value
%  I" coded integer index
  L=2^NoBits;
  delta=(Xmax-Xmin)/L;
pq=Xmin+I*delta;

