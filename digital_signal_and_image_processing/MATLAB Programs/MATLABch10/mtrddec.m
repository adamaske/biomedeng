function pq = mtrddec(NoBits,Xmax,indx)
% function pq = mtrddec(NoBits, Xmax, value)
% this routine is dequantizer.
% 
%  NoBits: number of bits used in quantization.
%  Xmax: overload value.
%  pq: output of quantized value
%  indx: integer index
%  
%  Note: the midtread method is used in this quantizer.
%
    delta = 2*abs(Xmax)/(2^NoBits-1);
    pq =indx*delta;
