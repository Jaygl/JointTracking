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

phi = [-pi/2:.1:pi/2];
theta = [0:.1:2*pi];

x = [mean(phi) mean(theta) mean(phi) mean(theta)];

for k = 1:1000
    %Determine pointing vectors
    j1 = [cos(x(1))*cos(x(2)) cos(x(1))*sin(x(2)) sin(x(1))];
    j2 = [cos(x(3))*cos(x(4)) cos(x(3))*sin(x(4)) sin(x(3))];
    
    %Calculate the cross products
    e1 = cross(g1, repmat(j1,[N 1]));
    e2 = cross(g2, repmat(j2,[N 1]));
    
    %Magnitude of each cross product
    e1_norm = sqrt(sum(e1.^2, 2));
    e2_norm = sqrt(sum(e2.^2, 2));
    
    %Error Vector
    err_vec = e1_norm - e2_norm;
    
    
end

