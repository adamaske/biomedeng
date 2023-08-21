function rvalue = muexpand(y,vmax, mu)
% this function performs mu-law exoanding
% usage:
% function rvalue = muexpand(y,vmax, mu)
% y  = input signal
% vmax = maximum amplitude
% mu = parameter for controlling the degree of compression, which must be the same 
% as the mu-law compander
% rvalue = output value from the mu-law expander
%
	y=y/vmax;              % normalization
% mu-law expanding
	rvalue=sign(y)*(vmax/mu)*((1+mu)^abs(y) -1);
