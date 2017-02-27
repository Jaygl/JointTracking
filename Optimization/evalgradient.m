function [ grad ] = evalgradient( x,x2,g1,g2 )
%EVALGRADIENT Summary of this function goes here
%   Detailed explanation goes here

c1 = cross(g1, repmat(x{1}',[size(g1,1) 1]));
c2 = cross(g2, repmat(x{2}',[size(g2,1) 1]));

n1 = cross(c1, g1);
n2 = cross(c2, g2);

d1 = sqrt(sum(c1.^2, 2));
d2 = sqrt(sum(c2.^2, 2));

grad1 = n1./d1;
grad2 = n2./d2;

fgrad1 = squeeze(sum(grad1,1))';
fgrad2 = squeeze(sum(grad1,1))';

grad{1} = fgrad1
grad{2} = -fgrad2

end

