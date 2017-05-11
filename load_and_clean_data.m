switch file
    case 1
        BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorBeginning.xlsx']);      
    case 2
        BigData = xlsread([pwd '\Data\MovingEdisonSensorForTwoSensorsBothMoving.xlsx']);
        if initialJ
            x0 = {};
            [x,y,z] = sph2cart(1.7, -.0708, 1);
            x0{1} = [x y z]';
            [x,y,z] = sph2cart(3.0, -.0708, 1);
            x0{2} = [x y z]';
        end
        % accel_mult = .061;
        accel_mult = .122;
        % accel_mult = .183;
    case 3
        BigData = xlsread([pwd '\Data\2SparkfunSensors042317Run1.xlsx']);
        accel_mult = 1000;
    case 4
        BigData = xlsread([pwd '\Data\2SparkfunSensors042317Run2.xlsx']);
    case 5
        BigData = xlsread([pwd '\Data\2SparkfunSensors042317Run3.xlsx']);
        accel_mult = 1000;
    case 6
        BigData = xlsread([pwd '\Data\May102017TwoSensorsInOfficeOnCardboard.xlsx']);
        accel_mult = 1000;
        T1_offset = -.8;
        T2_offset = 0;
end

N = size(BigData,1);

g1 = BigData(:,1:3);
a1 = BigData(:,4:6);
m1 = BigData(:,7:9);
deltaT1 = BigData(:,10);
T1 = BigData(:,11);9

g2 = BigData(:,13:15);
a2 = BigData(:,16:18);
m2 = BigData(:,19:21);
deltaT2 = BigData(:,22);
T2 = BigData(:,23);

%Offset
T1 = T1_offset + T1;
T2 = T2_offset + T2;

%First order approximation for g_dot

%Determine if T1 or T2 is larger...

%%% SHOULD ALSO FIND THE MAX(T1(1), T2(1)) VALUE AND CUT THERE

tmax = min(T1(end), T2(end));
tmin = max(T1(1), T2(1));
mask1 = T1 <= tmax;
mask2 = T2 <= tmax;
T1 = T1(mask1);
T2 = T2(mask2);
g1 = g1(mask1,:);
g2 = g2(mask2,:);
a1 = a1(mask1,:);
a2 = a2(mask2,:);
% g1dot = g1dot(mask1,:);
% g2dot = g2dot(mask2,:);
deltaT1 = deltaT1(mask1);
deltaT2 = deltaT2(mask2);
N = length(T1);
M = length(T2);
if N >= M
    %Use M as the points to resample to
    g1 = interp1(T1, g1, T2);
    a1 = interp1(T1, a1, T2);
%     g1dot = interp1(T1, g1dot, T2);
    T1 = T2;
    deltaT1 = deltaT2;
else
    %Use N as the points to resample to
    g2 = interp1(T2, g2, T1);
    a2 = interp1(T2, a2, T1);
%     g2dot = interp1(T2, g2dot, T1);
    T2 = T1;
    deltaT2 = deltaT1;
end

%First order approximation for g_dot

g1dot = diff(g1, 1, 1)./deltaT1(2:end);
g2dot = diff(g2, 1, 1)./deltaT2(2:end);

a1 = a1.*accel_mult/1000;
a2 = a2.*accel_mult/1000;
a1 = a1*9.8;
a2 = a2*9.8;

%Clip the dataset in order to have accurate g_dot values for the entire set
N = min(size(g1dot,1), size(g2dot,1));
g1 = g1(1:N,:);
g2 = g2(1:N,:);
a1 = a1(1:N,:);
a2 = a2(1:N,:);
deltaT1 = deltaT1(1:N,:);
deltaT2 = deltaT2(1:N,:);
T1 = T1(1:N,:);
T2 = T2(1:N,:);


