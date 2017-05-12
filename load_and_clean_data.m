%Requires the following variables to be defined:
%file = case number to look at
%filter_data = boolean (or 0/1) as to whether the data should be filtered
%g = Gravity. Default is 9.8, unsure whether this should be +/-
%fc = cutoff frequency for Butterworth filter (optional, defaultat 1/.3)

%WHEN ADDING A NEW DATASET >> T1_offset and T2_offset need to be
%determined and entered in.

switch file
    case 1 %This was the first dataset
        BigData1 = load('datalogFirst.txt');
        BigData2 = load('datalogWest.txt');
        T1_offset = -1;
        T2_offset = -.2;
    case 2
        BigData1 = load('datalogFirst2.txt');
        BigData2 = load('datalogWest2.txt');
        T1_offset = -.8;
        T2_offset = -.1;
    case 3
        BigData1 = load('datalogFirstNotDouble.txt');
        BigData2 = load('datalogWestDouble.txt');
        T1_offset = -.55;
        T2_offset = -.1;
    case 4
        BigData1 = load('datalogFirstXJ.txt');
        BigData2 = load('datalogWestXJ.txt');
        T1_offset = -.5;
        T2_offset = -.1;
    case 5
        BigData1 = load('datalogFirst30JX.txt');
        BigData2 = load('datalogWest60JY.txt');
        T1_offset = -.45;
        T2_offset = -.1;
end
samplerate = .03;
cutoff = 700;

g11 = BigData1(:,1:3);
a11 = BigData1(:,4:6);
T1 = BigData1(:,11);

g22 = BigData2(:,1:3);
a22 = BigData2(:,4:6);
T2 = BigData2(:,11);

%Offset
T1 = T1_offset + T1;
T2 = T2_offset + T2;

tmax = min(T1(end), T2(end));
t_goal = [0:samplerate:tmax];
g11 = interp1(T1, g11, t_goal');
a11 = interp1(T1, a11, t_goal');

g22 = interp1(T2, g22, t_goal');
a22 = interp1(T2, a22, t_goal');
    
%Filtering 
if filter_data
    fc = 1/.3; %1/.3 was working well ish
    fs = 1/.03;
    [m, n] = butter(6,fc/(fs/2));
    for k = 1:3
        a1(:,k) = filter(m, n, a11(:,k));
        g1(:,k) = filter(m, n, g11(:,k));
        a2(:,k) = filter(m, n, a22(:,k));
        g2(:,k) = filter(m, n, g22(:,k));
    end
else
    a1 = a11;
    a2 = a22;
    g1 = g11;
    g2 = g22;
end


% figure
% plot(t_goal(1:cutoff), a1(1:cutoff,3),'k')
% hold on
% plot(t_goal(1:cutoff), a11(1:cutoff,3), 'r')
% title('Smoothing results')

%First order approximation for g_dot
g1dot = diff(g1, 1, 1)/samplerate;
g2dot = diff(g2, 1, 1)/samplerate;

a1 = a1*g;
a2 = a2*g;

%Clip the dataset in order to have accurate g_dot values for the entire set
%(diff is going to cause us to lose one data point, so we clip them all by
%1. Note that using N has been made excessive in this version, but it works
%fine still.)
N = min(size(g1dot,1), size(g2dot,1));
g1 = g1(1:N,:);
g2 = g2(1:N,:);
a1 = a1(1:N,:);
a2 = a2(1:N,:);
t_goal = t_goal(1:N);
T1 = t_goal;
T2 = t_goal;

figure
plot(t_goal(1:cutoff),a1(1:cutoff,3),'k')
hold on
plot(t_goal(1:cutoff),a2(1:cutoff,3),'r')
title('A1 vs A2 - Time Alignment')

