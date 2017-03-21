file = 2;
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

phi = [-pi/2:.1:pi/2];
theta = [0:.1:2*pi];
for i = 1:length(phi)
    i
    for j = 1:length(theta)
        for k = 1:length(phi)
            for l = 1:length(theta)
                
                %Angle Set
                phi1 = phi(i);
                theta1 = theta(j);
                phi2 = phi(k);
                theta2 = theta(l);
                
                %Joint position vectors
                j1 = [cos(phi1)*cos(theta1) cos(phi1)*sin(theta1) sin(phi1)];
                j2 = [cos(phi2)*cos(theta2) cos(phi2)*sin(theta2) sin(phi2)];
                
                %Calculate the cross products
                e1 = cross(g1, repmat(j1,[N 1]));
                e2 = cross(g2, repmat(j2,[N 1]));
                
                %Magnitude of each cross product
                e1_norm = sqrt(sum(e1.^2, 2));
                e2_norm = sqrt(sum(e2.^2, 2));
                
                %Error Term
                errs = (e1_norm - e2_norm).^2;
                
                %Sum of the errors
                Psi(i, j, k, l) = sum(errs);
            end
        end
    end
end

[target_phi1 target_theta1 target_phi2 target_theta2] = ind2sub(size(Psi), find(Psi == ...
min(min(min(min(Psi))))));
[theta(target_theta1) phi(target_phi1) theta(target_theta2) phi(target_phi2)]
%Theta 1 and Phi 1
figure
surf(theta, phi, Psi(:,:,target_phi2, target_theta2));
xlabel('Phi')
ylabel('Theta')
zlabel('Sum(error^2)')
title('Varying Theta 1 and Phi 1')

%Theta 2 and Phi 2
figure
surf(theta, phi, squeeze(Psi(target_phi1, target_theta1, :,:)));
xlabel('Phi')
ylabel('Theta')
zlabel('Sum(error^2)')
title('Varying Theta 2 and Phi 2')


