% Macroeconomía dinámica 1 | ITAM | Primavera 2022
% Laboratorio 1
% Carlos Lezama
% Modelo de crecimiento neoclásico secuencial

global alpha beta delta A k0 T

alpha = 0.35;
beta = 0.99;
delta = 0.06;
A = 10;

% Ecuaciones características del estado estacionario
ss = @(css, kss) [(1 / beta) - (alpha * A * kss ^ (alpha - 1)) - (1 - delta);
                  (A * kss ^ alpha) - css - (delta * kss)];

aux = @(x) ss(x(1), x(2));
guess = [100; 100];

ss_solution = fsolve(aux, guess);

% Estado estacionario
css = ss_solution(1);
kss = ss_solution(2);
yss = A * kss ^ alpha;
wss = (1 - alpha) * yss;
rss = (alpha / kss) * yss;

% Transición del modelo
k0 = kss / 2;
T = 100;

initC = repelem(css, T)';
initK = repelem(kss, T - 1)';

init = [initC; initK];

transition_solution = fsolve(@(x) transition(x), init);
c = transition_solution(1:T);
k = [k0; transition_solution((T + 1):(2 * T - 1))];
y = ones(T, 1);
w = ones(T, 1);
r = ones(T, 1);

for t = 1:T
    y(t) = A * k(t) ^ alpha;
    w(t) = (1 - alpha) * y(t);
    r(t) = (alpha / k(t)) * y(t);
end

figure(3)

subplot(3,2,1)
plot(1:T, k);
title("Capital")
xlabel('$t$')
ylabel('$k_t$')

subplot(3,2,2)
plot(1:T, c);
title("Consumo")
xlabel('$t$')
ylabel('$c_t$')

subplot(3,2,3)
plot(1:T, y);
title("Producto")
xlabel('$t$')
ylabel('$y_t$')

subplot(3,2,4)
plot(1:T, w);
title("Salario real")
xlabel('$t$')
ylabel('$w_t$')

subplot(3,2,5)
plot(1:T, r);
title("Tasa de inter\'es")
xlabel('$t$')
ylabel('$r_t$')

function [F] = transition(x)
    global alpha beta delta A k0 T
    c = x(1:T);
    k = x((T + 1):(2 * T - 1));

    fe = ones(T - 1, 1);
    ff = ones(T, 1);

    for t = 1:(T - 1)
        fe(t) = beta * (c(t) / c(t + 1)) * ((alpha * A * k(t) ^ (alpha - 1)) + (1 - delta)) - 1;
    end

    ff(1) = (A * k0 ^ alpha) + ((1 - delta) * k0) - k(1) - c(1);
    for t = 2:(T - 1)
        ff(t) = (A * k(t - 1) ^ alpha) + ((1 - delta) * k(t - 1)) - c(t) - k(t);
    end
    ff(T) = (A * k(T - 1) ^ alpha) - (delta * k(T - 1)) - c(T);

    F = [ff; fe];
end
