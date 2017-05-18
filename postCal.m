clear
close all
clc

file = 8
cal_file = 6
filter_data = false;
g = 9.8;
lambda = .01;

load_and_clean_data

%%
load(['file_' num2str(cal_file) '_cal'])

%% Get the gyroscope-based flextion/extension angle
j1_r = repmat(j1,size(g1,1),1);
j2_r = repmat(j2,size(g2,1),1);
term1 = dot(g1,j1_r,2);
term2 = dot(g2,j2_r,2);
alpha_gyr = alpha_gyr_offset - cumtrapz(T1,term1-term2);
figure
plot(T1,alpha_gyr,'k')
title('Gyroscope-based flexion/extension angle')

%% Get the accelerometer-based flexion/extension angle
o1_r = repmat(o1, [size(g1,1) 1]);
o2_r = repmat(o2, [size(g1,1) 1]);
gamma1 = cross(g1, cross(g1, o1_r)) + cross(g1dot, o1_r);
gamma2 = cross(g2, cross(g2, o2_r)) + cross(g2dot, o2_r);

%Shifted accelerations onto the joint axes
a1_t = a1 - gamma1;
a2_t = a2 - gamma2; 

%Find the random vector c, which can not be || with j1 or j2
% ok = false;
% while ~ok
%     c = rand(1,3);
%     c = c/norm(c); %Make it a unit vector
%     if (dot(c,j1) < .8) && (dot(c,j2) <= .8)
%         ok = true;
%     end
% end
% %Currently hardcoded in, changing c appears to affect alpha_acc
% c = [0.5664 0.8237 0.0277];

%Define the joint planes
x1 = cross(j1,c);
y1 = cross(j1,x1);
x2 = cross(j2,c);
y2 = cross(j2,x2);

%Now project the accelerations onto the joint plane
x1_r = repmat(x1,size(a1,1),1);
y1_r = repmat(y1,size(a1,1),1);
x2_r = repmat(x2,size(a1,1),1);
y2_r = repmat(y2,size(a1,1),1);

a1x = dot(a1_t, x1_r, 2);
a1y = dot(a1_t, y1_r, 2);
a2x = dot(a2_t, x2_r, 2);
a2y = dot(a2_t, y2_r, 2);

%Determine the angle between the two projected vectors
%Need to be careful here with dimensions...
v1 = [a1x a1y];
v2 = [a2x a2y];
dots = dot(v1,v2,2);
crosses = a1x.*a2y - a1y.*a2x;

alpha_acc = atan2(dots, crosses)+alpha_acc_offset;
figure
plot(T1, alpha_acc)
title('Acceleration-based flexion/extension angle');

%Combine the angles together (could use a Kalman filter or the like)
alpha_c = zeros(length(T1),1);
alpha_c(1) = alpha_gyr(1);
for k = 2:length(T1)
    alpha_c(k) = lambda*alpha_acc(k)+(1-lambda)*(alpha_c(k-1)+alpha_gyr(k)-alpha_gyr(k-1));
end

figure
plot(T1, alpha_c)
title('Combined angle')