function [w,p]=hardT(w,Th)
% hard threshold function
N=length(w);
cnt=0;
for i=1:N
    if abs(w(i))<Th
        w(i)=0;
        cnt=cnt+1;
    end
end
p=cnt/N;