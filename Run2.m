%% Load all data
clear
clc
close all
file = 10
initialJ = 0;
load_and_clean_data2;
%% Perform Optimization

% Create the problem structure.
    manifold = spherefactory(3);
N = powermanifold(manifold, 2);
problem.M = N;

% Define the problem cost function and its gradient.
problem.cost  = @(x) costfunction_jvectors(x,g1,g2);

problem.egrad = @(x) evalgradient_jvectors(x,g1,g2);
% figure
% checkgradient(problem)

% Solve.
warning('off', 'manopt:getHessian:approx')

if ~initialJ
    [x, xcost, info] = trustregions(problem);        
else
    [x, xcost, info] = trustregions(problem, x0);  
end
j1 = x(1,:);
j2 = x(2,:);
j1 = j1{1}';
j2 = j2{1}';

[target_theta1 target_phi1 ~] = cart2sph(x{1}(1), x{1}(2), x{1}(3));
[target_theta2 target_phi2 ~] = cart2sph(x{2}(1), x{2}(2), x{2}(3));
[target_theta1 target_phi1]
[target_theta2 target_phi2]
figure;
semilogy([info.iter], [info.gradnorm], '.-');
xlabel('Iteration #');
ylabel('Gradient norm');
title('Convergence of the trust-regions algorithm on the sphere');

%%
%Third order approximation for g_dot
options.maxcostevals = 7500

% Create the problem structure.
manifold = euclideanfactory(2,3);

%In theory I could use another power manifold here and treat o1 and o2 as
%seperate vectors as I did for j1 and j2...
problem.M = manifold;

% Define the problem cost function and its gradient.
problem.cost  = @(x) costfunction_ovectors(x, g1, g2, g1dot, g2dot, a1, a2);
problem.egrad = @(x) evalgradient_ovectors(x, g1, g2, g1dot, g2dot, a1, a2);
% figure
% checkgradient(problem)

% Solve.
warning('off', 'manopt:getHessian:approx')
options.maxtime = 20;
% options.tolgradnorm = 1e-12;
options.useRand = true;
[x, xcost, info] = trustregions(problem, [], options);
% [x, fbest, info, options] = pso(problem)

o1hat = x(1,:)
o2hat = x(2,:)

[o1, o2] = optimizeO(o1hat, o2hat, j1, j2);

