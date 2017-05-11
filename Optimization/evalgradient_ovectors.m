function [ grad ] = evalgradient_ovectors(x, g1, g2, g1dot, g2dot, a1, a2  )
%EVALGRADIENT_OVECTORS Summary of this function goes here
%   Detailed explanation goes here

o1 = repmat(x(1,:), [size(g1,1) 1]);
o2 = repmat(x(2,:), [size(g1,1) 1]);

gamma1 = cross(g1, cross(g1, o1)) + cross(g1dot, o1);
gamma2 = cross(g2, cross(g2, o2)) + cross(g2dot, o2);

e1 = a1 - gamma1;
e2 = a2 - gamma2;

e1_norm = sqrt(sum(e1.^2, 2));
e2_norm = sqrt(sum(e2.^2, 2));

errs = e1_norm - e2_norm;
% finalerror = sum(errs.^2);

d1 = e1_norm;
d2 = e2_norm;

arg1 = a1 - gamma1;
arg2 = a2 - gamma2;

n1 = cross(cross(arg1,g1), g1) + cross(arg1, g1dot);
n2 = cross(cross(arg2,g2), g2) + cross(arg2, g2dot);

grad1 = 2*errs.*n1./d1;
grad2 = 2*errs.*n2./d2;

% fgrad1 = squeeze(sum(grad1,1));
% fgrad2 = squeeze(sum(grad2,1));

% grad = [fgrad1; -fgrad2];
grad = [sum(grad1,1); -sum(grad2,1)];
grad = -grad;
end

