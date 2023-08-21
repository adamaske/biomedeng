function [value ] = dmudec(cmp_code)
% this routine is created for simulation of 12-bit mu law decoding.
% usage:
% unction [value ] = dmudec(cmp_code)
% cmp_code = input mu-law encoded code
% value = recovered output value
%
  if (abs(cmp_code) >=0) & (abs(cmp_code)<16)
        value=cmp_code;
  end
   if (abs(cmp_code) >=16) & (abs(cmp_code)<32)
       value=sgn(cmp_code)*(16+(abs(cmp_code)-16));
  end
  if (abs(cmp_code) >=32) & (abs(cmp_code)<48)
       value=sgn(cmp_code)*(32+(abs(cmp_code)-32)*2+1);
  end
 if (abs(cmp_code) >=48) & (abs(cmp_code)<64)
        value=sgn(cmp_code)*(64+(abs(cmp_code)-48)*4+2);
  end
  if (abs(cmp_code) >=64) & (abs(cmp_code)<80)
      value=sgn(cmp_code)*(128+(abs(cmp_code)-64)*8+4);
  end
 if (abs(cmp_code) >=80) & (abs(cmp_code)<96)
      value=sgn(cmp_code)*(256+(abs(cmp_code)-80)*16+8);
  end
 if (abs(cmp_code) >=96) & (abs(cmp_code)<112)
       value=sgn(cmp_code)*(512+(abs(cmp_code)-96)*32+16);
  end
 if (abs(cmp_code) >=112) & (abs(cmp_code)<128)
         value=sgn(cmp_code)*(1024+(abs(cmp_code)-112)*64+32);
  end
