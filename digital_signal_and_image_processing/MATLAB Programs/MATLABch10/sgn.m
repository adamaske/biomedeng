function sgn = sgn(sgninp)
%
% sign function
% if siginp >=0 then sign=1
% else sign =-1
%
  if sgninp >= 0
     opt = 1;
  else
     opt = -1;
  end
  sgn = opt;
