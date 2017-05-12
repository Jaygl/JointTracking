%% Set Parameters and load all data
clear
clc
close all

debug_mode = false;
filter_data = 1;
g = 9.8; %unclear whether this should be +/-, flipping sign flips o vectors
file = 5

load_and_clean_data;
%% Perform Optimization for j vectors

% Create the problem structure.
manifold = spherefactory(3);
N = powermanifold(manifold, 2);
problem.M = N;

% Define the problem cost function and its gradient.
problem.cost  = @(x) costfunction_jvectors(x,g1,g2);
problem.egrad = @(x) evalgradient_jvectors(x,g1,g2);
if debug_mode
    figure
    checkgradient(problem)
end

% Solve.
warning('off', 'manopt:getHessian:approx')
[x, xcost, info] = trustregions(problem);
j1 = x(1,:);
j2 = x(2,:);
% Manopt returns a cell array, need to convert back to a vector
j1 = j1{1}';
j2 = j2{1}';

%This isn't particularly necessary, except for comparing to the brute-force
%approach. i.e. theta/phi representation is not used for computation.
[target_theta1 target_phi1 ~] = cart2sph(x{1}(1), x{1}(2), x{1}(3));
[target_theta2 target_phi2 ~] = cart2sph(x{2}(1), x{2}(2), x{2}(3));
if debug_mode
    [target_theta1 target_phi1]
    [target_theta2 target_phi2]
    figure;
    semilogy([info.iter], [info.gradnorm], '.-');
    xlabel('Iteration #');
    ylabel('Gradient norm');
    title('Convergence of the trust-regions algorithm on the sphere');
end

%% Perform Optimization for o vectors

% Create the problem structure.
manifold = euclideanfactory(2,3);
problem.M = manifold;

% Define the problem cost function and its gradient.
problem.cost  = @(x) costfunction_ovectors(x, g1, g2, g1dot, g2dot, a1, a2);
problem.egrad = @(x) evalgradient_ovectors(x, g1, g2, g1dot, g2dot, a1, a2);
if debug_mode
    figure
    checkgradient(problem)
end

% Solve.
warning('off', 'manopt:getHessian:approx')
% options.tolgradnorm = 1e-12;
options.useRand = true;
[x, xcost, info] = trustregions(problem, [], options);

%Manopt returns the 2 o_hat vectors
o1hat = x(1,:)
o2hat = x(2,:)

[o1, o2] = optimizeO(o1hat, o2hat, j1, j2);

