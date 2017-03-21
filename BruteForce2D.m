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

phi = [-pi/2:.05:pi/2];
theta = [0:.05:2*pi];

for k = 1:length(phi)
    for j = 1:length(theta)
        
        %Angle Set
        phi1 = phi(k);
        phi2 = 1;
        theta1 = theta(j);
        theta2 = pi/2;
        
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
        Psi(k,j) = sum(errs);
    end
end
figure
surf(theta, phi, Psi);
xlabel('Phi')
ylabel('Theta')
zlabel('Sum(error^2)')