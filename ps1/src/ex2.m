% Dynamic macroeconomics 1 | ITAM | Spring 2022
% 1st problem set
% Carlos Lezama
% Nonlinear equations / systems

f = @(x) ((5 * x - 4) / (x - 1));

x = [0.75 0.87 1.02];

y = [];

for i = 1:length(x)
    y(i) = fsolve(f, x(i));
end

[x; y]'
