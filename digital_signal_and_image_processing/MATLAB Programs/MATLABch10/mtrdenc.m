function [indx, pq ] = mtrdenc(NoBits,Xmax,value)
% function pq = mtrdenc(NoBits, Xmax, value)
% this routine is created for simulation of midtread uniform quatizer.
% 
%  NoBits: number of bits used in quantization.
%  Xmax: overload value.
%  value: input to be quantized.
%  pq: output of quantized value
%  indx: integer index
%  
%  Note: the midtread method is used in this quantizer.
%

  if NoBits == 0
    pq = 0;
    indx=0;
  else
    delta = 2*abs(Xmax)/(2^NoBits-1);
    Xrmax=delta*(2^NoBits/2-1);
    if abs(value) >= Xrmax
       tmp = Xrmax;
    else
       tmp = abs(value);
    end
    indx=round(tmp/delta);
    pq =indx*delta;
    if  value < 0
      pq = -pq;
      indx=-indx;
    end
  end
