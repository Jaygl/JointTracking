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
problem.M = manifold;

% Define the problem cost function and its gradient.
% f = @costfunction;
problem.cost  = @(x) costfunction(x,g1);
problem.egrad = @(x) evalgradient(x,g1);

figure
checkgradient(problem)


% Solve.
[x, xcost, info] = trustregions(problem);          %#ok<ASGLU>

% Display some statistics.
% figure;
% semilogy([info.iter], [info.gradnorm], '.-');
% xlabel('Iteration #');
% ylabel('Gradient norm');
% title('Convergence of the trust-regions algorithm on the sphere');





