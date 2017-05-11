function [ finalerror ] = costfunction_ovectors( x, g1, g2, g1dot, g2dot, a1, a2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

o1 = repmat(x(1,:), [size(g1,1) 1]);
o2 = repmat(x(2,:), [size(g1,1) 1]);

gamma1 = cross(g1, cross(g1, o1)) + cross(g1dot, o1);
gamma2 = cross(g2, cross(g2, o2)) + cross(g2dot, o2);

e1 = a1 - gamma1;
e2 = a2 - gamma2;

e1_norm = sqrt(sum(e1.^2, 2));
e2_norm = sqrt(sum(e2.^2, 2));

errs = (e1_norm - e2_norm).^2;
finalerror = sum(errs);

end

