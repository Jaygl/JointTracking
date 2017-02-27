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

load('FirstCalc.mat')

[target_phi1 target_theta1 target_phi2 target_theta2] = ind2sub(size(Psi), find(Psi == ...
min(min(min(min(Psi))))))

% %Theta 1 and Phi 1
% figure
% surf(theta, phi, Psi(:,:,target_phi2, target_theta2));
% xlabel('Phi')
% ylabel('Theta')
% zlabel('Sum(error^2)')
% title('Varying Theta 1 and Phi 1')
% 
% %Theta 2 and Phi 2
% figure
% surf(theta, phi, squeeze(Psi(target_phi1, target_theta1, :,:)));
% xlabel('Phi')
% ylabel('Theta')
% zlabel('Sum(error^2)')
% title('Varying Theta 2 and Phi 2')

[x y z] = sph2cart(theta(target_theta1), phi(target_phi1), 1);
j1 = [x y z]
j1 = [cos(phi(target_phi1))*cos(theta(target_theta1)) cos(phi(target_phi1))* ...
    sin(theta(target_theta1)) sin(phi(target_phi1))]
[x y z] = sph2cart(theta(target_theta2), phi(target_phi2), 1);
j2 = [x y z]
j2 = [cos(phi(target_phi2))*cos(theta(target_theta2)) cos(phi(target_phi2))* ...
    sin(theta(target_theta2)) sin(phi(target_phi2))]
clear x
x{1} = j1';
x{2} = j2';
costfunction(x,g1,g2)
min(min(min(min(Psi))))

e1 = cross(g1, repmat(j1,[N 1]));
e2 = cross(g2, repmat(j2,[N 1]));

%Magnitude of each cross product
e1_norm = sqrt(sum(e1.^2, 2));
e2_norm = sqrt(sum(e2.^2, 2));

%Error Term
errs = (e1_norm - e2_norm).^2;
shouldbe = sum(errs)
