file = 2;
% accel_mult = .061;
accel_mult = .122;
% accel_mult = .183;

switch file
case 1
    BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorBeginning.xlsx']);
case 2
    BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorsBothMoving.xlsx']);
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
%%
%Third order approximation for g_dot
g1m2 = [zeros(4,3); g1];
g1m1 = [zeros(3,3); g1; zeros(1,3)];
g1p1 = [zeros(1,3); g1; zeros(3,3)];
g1p2 = [g1; zeros(4,3)];
deltat = mean(deltaT1);

g1dot = (1*g1m2 - 8*g1m1 + 8*g1p1 - 1*g1p2)/(12*deltat);
g1dot = g1dot(5:end-4,:);

g2m2 = [zeros(4,3); g2];
g2m1 = [zeros(3,3); g2; zeros(1,3)];
g2p1 = [zeros(1,3); g2; zeros(3,3)];
g2p2 = [g2; zeros(4,3)];
deltat = mean(deltaT2);
g2dot = (1*g2m2 - 8*g2m1 + 8*g2p1 - 1*g2p2)/(12*deltat);
g2dot = g2dot(5:end-4,:);

%Clip the dataset in order to have accurate g_dot values for the entire set
%FOR DEBUGGING
g1o = g1;
g2o = g2;
% g1 = g1(3:end-2,:);
% g2 = g2(3:end-2,:);
% a1 = a1(3:end-2,:);
% a2 = a2(3:end-2,:);

g1dot2 = diff(g1, 1, 1)./deltat;
g2dot2 = diff(g2, 1, 1)./deltat;
a1 = a1.*accel_mult/1000;
a2 = a2.*accel_mult/1000;

g1 = g1(1:size(g1dot2,1),:);
g2 = g2(1:size(g1dot2,1),:);
a1 = a1(1:size(g1dot2,1),:);
a2 = a2(1:size(g1dot2,1),:);

g1dot = g1dot2;
g2dot = g2dot2;
options.maxcostevals = 7500

% Create the problem structure.
manifold = euclideanfactory(2,3);

%In theory I could use another power manifold here and treat o1 and o2 as
%seperate vectors as I did for j1 and j2...
problem.M = manifold;

% Define the problem cost function and its gradient.
problem.cost  = @(x) costfunction_ovectors(x, g1, g2, g1dot, g2dot, a1, a2);
problem.egrad = @(x) evalgradient_ovectors(x, g1, g2, g1dot, g2dot, a1, a2);
checkgradient(problem)

% Solve.
warning('off', 'manopt:getHessian:approx')
% [x, xcost, info] = trustregions(problem);          %#ok<ASGLU>
% [target_theta1 target_phi1 ~] = cart2sph(x{1}(1), x{1}(2), x{1}(3))
% [target_theta2 target_phi2 ~] = cart2sph(x{2}(1), x{2}(2), x{2}(3))
% [xbest, fbest, info, options] = pso(problem, [], options)
% Display some statistics.
% figure;
% semilogy([info.iter], [info.gradnorm], '.-');
% xlabel('Iteration #');
% ylabel('Gradient norm');
% title('Convergence of the trust-regions algorithm on the sphere');
