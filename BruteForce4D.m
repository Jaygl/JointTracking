file = 5;
filter_data = 1;
g = 9.8;
load_and_clean_data

interval_size = .1;
phi = [-pi/2:interval_size:pi/2];
theta = [0:interval_size:2*pi];

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
zlabel('Sum of squared error')
title('Varying Theta 1 and Phi 1')

%Theta 2 and Phi 2
figure
surf(theta, phi, squeeze(Psi(target_phi1, target_theta1, :,:)));
xlabel('Phi')
ylabel('Theta')
zlabel('Sum of squared error')
title('Varying Theta 2 and Phi 2')
save(['BruteForce4Dfile' num2str(file)], 'Psi', 'phi', 'target_phi1', 'target_theta1', 'target_phi2', 'target_theta2', 'theta')



