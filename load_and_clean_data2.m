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
        %BigData = xlsread([pwd '\Data\May102017TwoSensorsInOfficeOnCardboard.xlsx']);
        BigData1 = load('datalogFirst.txt');
        BigData2 = load('datalogWest.txt');
        accel_mult = 1000;
        T1_offset = -1;
        T2_offset = -.2;
end
samplerate = .03;
cutoff = 200;

g1 = BigData1(:,1:3);
a1 = BigData1(:,4:6);
% m1 = BigData1(:,7:9);
% deltaT1 = BigData1(:,10);
T1 = BigData1(:,11);

g2 = BigData2(:,1:3);
a2 = BigData2(:,4:6);
% m2 = BigData2(:,7:9);
% deltaT2 = BigData2(:,10);
T2 = BigData2(:,11);

%Offset
T1 = T1_offset + T1;
T2 = T2_offset + T2;

tmax = min(T1(end), T2(end));
t_goal = [0:samplerate:tmax];
g1 = interp1(T1, g1, t_goal');
a1 = interp1(T1, a1, t_goal');

g2 = interp1(T2, g2, t_goal');
a2 = interp1(T2, a2, t_goal');
    
%First order approximation for g_dot

g1dot = diff(g1, 1, 1)/samplerate;
g2dot = diff(g2, 1, 1)/samplerate;

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
t_goal = t_goal(1:end-1);
T1 = t_goal;
T2 = t_goal;

figure
plot(t_goal(1:cutoff),a1(1:cutoff,3),'k')
hold on
plot(t_goal(1:cutoff),a2(1:cutoff,3),'r')

