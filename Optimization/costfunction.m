function [ finalerror ] = costfunction( x, g1, g2 )
%COSTFUNCTION Summary of this function goes here
%   Detailed explanation goes here

%Calculate the cross products
e1 = cross(g1, repmat(x{1}',[size(g1,1) 1]));
e2 = cross(g2, repmat(x{2}',[size(g2,1) 1]));

%Magnitude of each cross product
e1_norm = sqrt(sum(e1.^2, 2));
e2_norm = sqrt(sum(e2.^2, 2));

%Total error
errs = (e1_norm - e2_norm).^2;
finalerror = sum(errs);

%For testing with partialegrad
% e1_2 = e1_norm.^2;
% e2_2 = e2_norm.^2;
% cost1 = sum(e1_2);
% cost2 = sum(e2_2);

end