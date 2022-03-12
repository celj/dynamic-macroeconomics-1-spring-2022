% Laboratorio 1
% Carlos Lezama
% Macroeconomía dinámica 1 | ITAM | Primavera 2022
% Solución de ecuaciones no lineales

f = @(x) ((5 * x - 4) / (x - 1));

x = [0.75 0.87 1.02];

y = [];

for i = 1:length(x)
    y(i) = fsolve(f, x(i));
end

x
y
