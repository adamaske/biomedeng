function pq = biqtdec(NoBits,Xmin,Xmax,I)
% function pq = biqtdec(NoBits, Xmin, Xmax, I)
% this routine is created for simulation of uniform quantizer.
% 
%  NoBits: number of bits used in quantization.
%  Xmax: overload value.
%  pq: output of quantized value
%  I" coded integer index

  L=2^NoBits;
  delta=(Xmax-Xmin)/L;
  pq=Xmin+I*delta;
