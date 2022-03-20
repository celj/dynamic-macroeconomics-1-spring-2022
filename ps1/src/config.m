% Dynamic macroeconomics 1 | ITAM | Spring 2022
% 1st problem set
% Carlos Lezama
% Configuration

format shortG

set(groot, "DefaultAxesTickLabelInterpreter", "latex");
set(groot, "DefaultLegendInterpreter", "latex");
set(groot, "DefaultLegendLocation", "southeast");
set(groot, "DefaultTextInterpreter", "latex");

set(0, "DefaultLineLineWidth", 1);
set(0,  "DefaultAxesFontSize", 14);

options = optimoptions('fsolve', 'Diagnostics', 'off', 'Display', 'off');
