%3*1Ä£°å¸ßË¹ÂË²¨
function [g] = gaussian_filter( sigma )
% 3sigma rule
n = 2*round(3.5 * sigma)+1;
x = 1:n;
x = x-ceil(n/2);
% Sample the gaussian function to generate the filter taps.
g = exp(-(x.^2)/(2*sigma^2))/(sigma*sqrt(2*pi));
g=g/sum(g);
end