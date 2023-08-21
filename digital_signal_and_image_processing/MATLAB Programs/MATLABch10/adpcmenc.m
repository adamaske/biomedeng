function iiout =  adpcmenc(input)
% this function performs ADPCM encoding
% function iiout =  adpcmenc(input)
% usage:
% input = input value
% iiout = output index
%
% quantization tables 
fitable = [0 0 0 1 1 1 1 3 7];
witable = [-0.75 1.13 2.56 4.00 7.00 12.38 22.19 70.13 ];
qtable = [ -0.98 0.62 1.38 1.91 2.34 2.72  3.12 ];
invqtable = [0.031 1.05 1.66 2.13 2.52 2.91 3.32 ];

lgth = length(input);
sr = zeros(1,2); pk = zeros(1,2);
a = zeros(1,2);  b = zeros(1,6); 
dq = zeros(1,6); ii= zeros(1,lgth);
y=0; ap = 0; al = 0; yu=0; yl = 0; dms = 0; dml = 0; tr = 0; td = 0;
for k = 1:lgth
  sl = input(k);
%
% predict zeros
% 
  sez = b(1)*dq(1);
 for i=2:6   
  sez = sez + b(i)*dq(i);
 end
 se = a(1)*sr(1)+a(2)*sr(2)+ sez;
  d = sl - se;
%
% assume quantization 
%
  dqq = log10(abs(d))/log10(2.0)-y;
     ik= 0;
     for i=1:7
       if dqq > qtable(i) 
	 ik = i;
       end
     end
  if d < 0
    ik = -ik;
  end
  ii(k) = ik;
  yu = (31.0/32.0)*y + witable(abs(ik)+1)/32.0;
  if yu > 10.0
    yu = 10.0;
  end
  if yu < 1.06
    yu = 1.06;
  end
  yl = (63.0/64.0)*yl+yu/64.0;
%
%inverse quantization
%
  if ik == 0
    dqq = 2^(-y);
  else
    dqq = 2^(invqtable(abs(ik))+y);
  end
  if ik < 0
    dqq = -dqq;
  end
  srr =  se + dqq;
  dqsez = srr+sez-se;
%
% Update state
%
 pk1 = dqsez;
%
% Adaptive predictor coefficient
%
     if tr == 1
	a = zeros(1,2); b = zeros(1,6);
	tr = 0;
             td = 0; %set for the time being
     else
% update predictor poles   
%   update a2 first
       a2p = (127.0/128.0)*a(2);
       if abs(a(1)) <= 0.5
	  fa1 = 4.0*a(1);
       else
	  fa1 = 2.0*sgn(a(1));
       end
        a2p=a2p+(sign(pk1)*sgn(pk(2))-fa1*sign(pk1)*sgn(pk(1)))/128.0;
       if abs(a2p) > 0.75 
	a2p = 0.75*sgn(a2p);
       end
	a(2) = a2p;
%
%  update a1 
       a1p = (255.0/256.0)*a(1);
	 a1p = a1p + 3.0*sign(pk1)*sgn(pk(1))/256.0;
          if abs(a1p) > 15.0/16.0-a2p
	    a1p = 15.0/16.0 -a2p;
          end
       a(1) = a1p;
%
% update b coefficients
%
  for i= 1:6
    b(i) = (255.0/256.0)*b(i)+sign(dqq)*sgn(dq(i))/128.0;
  end
  if  a2p < -0.7185
    td = 1;
  else
    td = 0;
  end
  if a2p < -0.7185 & abs(dq(6)) > 24.0*2^(yl)
    tr = 1;
  else
    tr = 0;
  end
  for i=6:-1:2
    dq(i) = dq(i-1);
  end
  dq(1) = dqq;  pk(2) = pk(1); pk(1) = pk1;  sr(2) = sr(1); sr(1) = srr;
%
% adaptive speed control
%
  dms = (31.0/32.0)*dms; dms = dms + fitable(abs(ik)+1)/32.0;
  dml = (127.0/128.0)*dml; dml = dml + fitable(abs(ik)+1)/128.0;
  if ap > 1.0
    al = 1.0;
  else
    al = ap;
  end
  ap = (15.0/16.0)*ap;
  if abs(dms-dml) >= dml/8.0
     ap = ap + 1/8.0;
  end
  if y < 3
     ap = ap +1/8.0;
  end
  if td == 1
     ap = ap + 1/8.0;
  end
  if tr == 1
    ap = 1.0;
  end
  y = al*yu + (1.0-al)*yl;
 end
end
iiout = ii;
