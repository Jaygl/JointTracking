function [ grad ] = evalgradient_old( x, g1 )
%EVALGRADIENT Summary of this function goes here
%   Detailed explanation goes here

e1 = cross(g1, repmat(x',[size(g1,1) 1]));
e2 = cross(e1, repmat(x',[size(g1,1) 1]));
e3 = sqrt(sum(e1.^2, 2));
grad = e2./e3;
grad = squeeze(sum(grad,1))';
size(grad)

end

