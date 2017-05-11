function [o1 o2] = optimizeO( o1hat, o2hat, j1, j2 )
%OPTIMIZEO Summary of this function goes here
%   Detailed explanation goes here

o1 = o1hat - j1 * (dot(o1hat,j1) + dot(o2hat,j2))/2;
o2 = o2hat - j2 * (dot(o1hat,j1) + dot(o2hat,j2))/2;

end

