function qvalue = mulaw(vin, vmax, mu)
% this function performs mu-law companding
% Usage:
% function qvalue = mulaw(vin, vmax, mu)
% vin = input vvalue
% vmax = input value
% mu = parameter for controlling the degree of compression which must be the same
% qvalue = output value form the mu-law compander
% as the mu-law expander
%
	vin = vin/vmax;            % normalization
% mu-law companding formula
	qvalue = vmax*sign(vin)*log(1+mu*abs(vin))/log(1+mu);
