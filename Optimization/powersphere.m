%% Load all data
BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorBeginning.xlsx']);
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
% problem.ncostterms = 2;
problem.cost  = @(x) costfunction(x,g1,g2);
problem.egrad = @(x) evalgradient(x,[1],g1,g2);
checkgradient(problem)


% Solve.
% [x, xcost, info] = trustregions(problem);          %#ok<ASGLU>
% [xbest, fbest, info, options] = pso(problem)
% Display some statistics.
% figure;
% semilogy([info.iter], [info.gradnorm], '.-');
% xlabel('Iteration #');
% ylabel('Gradient norm');
% title('Convergence of the trust-regions algorithm on the sphere');





