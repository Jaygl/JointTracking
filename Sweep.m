o1dim = 1
o2dim = 1
delta1 = [0:.005:.3];
delta2 = [-.3:.005:0];

for i = 1:length(delta1)
    for j = 1:length(delta2)
        x = [o1;o2];
        x(1,o1dim) = delta1(i);
        x(2,o2dim) = delta2(j);
        Psi(i,j) = costfunction_ovectors(x,g1,g2,g1dot,g2dot,a1,a2);
    end
end
figure
surf(delta1, delta2,Psi)
min(min(Psi))
[i,j] = find(Psi == min(min(Psi)));
delta1(i)
delta2(j)
x = [o1;o2];
costfunction_ovectors(x,g1,g2,g1dot,g2dot,a1,a2)
