function [cmp_code ] = dmuenc(NoBits, value)
% this routine is created for simulation of 12-bit mu law compression.
% function [cmp_code ] = dmuenc(NoBits, value)
% NoBits = number of bits for the data
% value = input value
% cmp_code = output code
%
  scale = NoBits-12;
  value=value*2^(-scale);  % scale to 12 bit 
  if (abs(value) >=0) & (abs(value)<16)
        cmp_code=value;
  end
   if (abs(value) >=16) & (abs(value)<32)
       cmp_code=sgn(value)*(16+fix(abs(value)-16));
  end
  if (abs(value) >=32) & (abs(value)<64)
       cmp_code=sgn(value)*(32+fix((abs(value) -32)/2));
  end
 if (abs(value) >=64) & (abs(value)<128)
        cmp_code=sgn(value)*(48+fix((abs(value) -64)/4));
  end
  if (abs(value) >=128) & (abs(value)<256)
      cmp_code=sgn(value)*(64+fix((abs(value) -128)/8));
  end
 if (abs(value) >=256) & (abs(value)<512)
      cmp_code=sgn(value)*(80+fix((abs(value) -256)/16));
  end
 if (abs(value) >=512) & (abs(value)<1024)
       cmp_code=sgn(value)*(96+fix((abs(value) -512)/32));
  end
 if (abs(value) >=1024) & (abs(value)<2048)
         cmp_code=sgn(value)*(112+fix((abs(value) -1024)/64));
  end
