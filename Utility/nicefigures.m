function nicefigures(fontSize)
if nargin < 1,
    fontSize = 14;
end
set(0, 'defaultAxesFontSize', fontSize);
set(0, 'defaultAxesFontWeight', 'b');
set(0, 'defaultAxesLineWidth', 2);
set(0, 'defaultTextFontSize', fontSize);
set(0, 'defaultTextFontWeight', 'b');
set(0, 'defaultLineLineWidth', 2);
set(0, 'defaultLineMarkerSize', 10);
set(0, 'defaultFigureColor', 'w');
return;
