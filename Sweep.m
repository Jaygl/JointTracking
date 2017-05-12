%This is a quick script for visualizing the costfunction locally around the
%point [o1;o2] (which has 6 coordinates). It assumes all data has already
%been loaded and is being called immediately after 'Run'. The goal is to
%sweep through 2 of the 6 variables that define the 2 ovectors and
%calculate the cost at each pair, which produces a 2D surface (in R^3).
%The script assumes it will sweep over one variable in o1 and one variable
%in o2. The variables to sweep over are determined by o1dim and o2dim,
%where they equal 1, 2, or 3 corresponding to x, y, or z. The range1 and
%range2 values should be adjusted for the particular problem of interest.
%Once complete, it will generate a surface plot showing cost values around
%the point [o1;o2] where the 2 defined dimensions have been swept through
%the 2 defined ranges.
dims = 'xyz';

o1dim = 2;
o2dim = 1;
display(['Sweeping over ' dims(o1dim) ' values for o1 and ' dims(o2dim) ' values for o2.'])
range1 = [0:.005:.4];
range2 = [-.8:.005:0];

for i = 1:length(range1)
    for j = 1:length(range2)
        x = [o1;o2];
        x(1,o1dim) = range1(i);
        myx(i,j) = range1(i);
        x(2,o2dim) = range2(j);
        myy(i,j) = range2(j);
        Psi(i,j) = costfunction_ovectors(x,g1,g2,g1dot,g2dot,a1,a2);
    end
end
figure
surf(myx,myy,Psi)
title('Parameter Sweep of cost function along o1 and o2')
xlabel([dims(o1dim) ' value of o1 (m)'])    
ylabel([dims(o2dim) ' value of o2 (m)'])
colorbar

display(sprintf('The minimum cost found by along the grid: %.3f: ', min(min(Psi))))
[i,j] = find(Psi == min(min(Psi)));
display(sprintf('Grid minimum found at: %.3f, %.3f', range1(i), range2(j)))
x = [o1;o2];
display(sprintf('The minimum cost found by Manopt: %.3f: ', costfunction_ovectors(x,g1,g2,g1dot,g2dot,a1,a2)))
display(sprintf('Manopt minimum found at: %.3f, %.3f', o1(o1dim), o2(o2dim)))
