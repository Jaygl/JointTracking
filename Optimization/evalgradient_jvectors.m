function [ grad ] = evalgradient( x,g1,g2 )
%EVALGRADIENT Summary of this function goes here
%   Detailed explanation goes here

c1 = cross(g1, repmat(x{1}',[size(g1,1) 1]));
c2 = cross(g2, repmat(x{2}',[size(g2,1) 1]));

%%% Calculate the error
%Magnitude of each cross product
e1_norm = sqrt(sum(c1.^2, 2));
e2_norm = sqrt(sum(c2.^2, 2));

%Total error
errs = (e1_norm - e2_norm);
% finalerror = sum(errs);
%%%%

%%% Calculate the derivatives
n1 = cross(c1, g1);
n2 = cross(c2, g2);

d1 = sqrt(sum(c1.^2, 2));
d2 = sqrt(sum(c2.^2, 2));

%Old
% grad1 = n1./d1;
% grad2 = n2./d2;
%Proper
grad1 = 2*errs.* n1./d1;
grad2 = 2*errs.* n2./d2;

fgrad1 = squeeze(sum(grad1,1))';
fgrad2 = squeeze(sum(grad2,1))';
%This is for testing
grad{1} = fgrad1;
grad{2} = -fgrad2;
%This is the proper gradient (MAYBE NOT)
% grad{1} = finalerror*2*fgrad1;
% grad{2} = finalerror*2*-fgrad2;

end

