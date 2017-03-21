%% Load all data
file = 2
switch file
    case 1
        BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorBeginning.xlsx']);
        
    case 2
        BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorsBothMoving.xlsx']);
        x0 = {};
        [x,y,z] = sph2cart(1.7, -.0708, 1);
        x0{1} = [x y z]';
        [x,y,z] = sph2cart(3.0, -.0708, 1);
        x0{2} = [x y z]';
end

N = size(BigData,1);
g1 = BigData(:,1:3);
a1 = BigData(:,4:6);
m1 = BigData(:,7:9);
deltaT1 = BigData(:,10);
T1 = BigData(:,11);

g2 = BigData(:,13:15);
a2 = BigData(:,16:18);
m2 = BigData(:,19:21);
deltaT2 = BigData(:,22);
T2 = BigData(:,23);

%% Perform Optimization

% Create the problem structure.
manifold = spherefactory(3);
N = powermanifold(manifold, 2);
problem.M = N;

% Define the problem cost function and its gradient.
% problem.ncostterms = size(g1,1);
problem.cost  = @(x) costfunction_jvectors(x,g1,g2);
%egrad gives incorrect slope (1 vs 2), correct residual
%grad gives incorrect slope (1 vs 2), incorrect residual

problem.egrad = @(x) evalgradient_jvectors(x,g1,g2);
checkgradient(problem)

% Solve.
warning('off', 'manopt:getHessian:approx')
[x, xcost, info] = trustregions(problem, x0);          %#ok<ASGLU>
[target_theta1 target_phi1 ~] = cart2sph(x{1}(1), x{1}(2), x{1}(3))
[target_theta2 target_phi2 ~] = cart2sph(x{2}(1), x{2}(2), x{2}(3))
% [xbest, fbest, info, options] = pso(problem)
% Display some statistics.
figure;
semilogy([info.iter], [info.gradnorm], '.-');
xlabel('Iteration #');
ylabel('Gradient norm');
title('Convergence of the trust-regions algorithm on the sphere');





