function B=firfs(N,Hk)
%  B=firfs(N,Hk)
%  Fir filter design using the frequency sampling method.
%  Input parameters:
%  N: the number of filter coefficients.
%     note: N must be odd number.
%  Hk: sampled frequency reponse for k=0,1,2,...,M=(N-1)/2.
%  Output:
%  B: FIR filter coefficients.
	M=(N-1)/2;
	for n=1:1:N
	  B(n)=(1/N)*(Hk(1)+...
	  2*sum(Hk(2:1:M+1)...
	  .*cos(2*pi*([1:1:M])*(n-1-M)/N)));
        end
