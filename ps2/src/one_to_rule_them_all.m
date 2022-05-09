% Dynamic macroeconomics 1 | ITAM | Spring 2022
% 2nd problem set
% Carlos Lezama

clc;
clear all;
close all;

config;

% Parameters

beta = 0.99;
A = 1;
alpha = 0.35;
delta = 0.06;
theta = [0.8, 1, 1.2];

n = 10000;

PI = [0.5, 0.3, 0.2;
      0.1, 0.7, 0.2;
      0.1, 0.4, 0.5];

% Asymptotic distribution

asymptoticPI = PI^n;

asymptoticPI^2

% Value function iteration

kss = ((1 / (alpha)) * ((1 / beta) - (1 - delta)))^(1 / (alpha - 1));

p = 500;

kGrid = linspace(0.5 * kss, 1.5 * kss, p);

q = 3;

aux1 = theta' * (A * (kGrid.^alpha)) + (1 - delta) * ones(q, 1) * kGrid;
aux1 = aux1(:);
aux1 = aux1 * ones(1, p);

M = aux1 - ones(p * q, 1) * kGrid;

M(M < 0) = 0;
M = log(M);

Iq = eye(q); 

E = [];

for i = 1:p
    E = [E; Iq]; 
end

V0 = zeros(p * q, 1); 
V1 = zeros(p * q, 1);

tol = 1e-3;

dist = 10;

while dist > tol
    [V1, G] = max(M + beta * (E * (PI * reshape(V0, q, p))), [], 2);
    dist = norm(V1-V0);
    V0 = V1;
end

G = reshape(G, q, p);
V1 = reshape(V1, q, p);

K = ones(q, p);
C = ones(q, p);

for i = 1:q    
    K(i, :) = kGrid(G(i, :)); 
    C(i, :) = theta(i) * A * (kGrid.^alpha) + (1 - delta) * kGrid - kGrid(G(i, :));
end

% Capital

figure(1)
subplot(3, 1, 1);
plot(kGrid, K(1, :), 'b', kGrid, K(2, :), 'r', kGrid, K(3, :), 'g')
legend('$\theta_1$', '$\theta_2$', '$\theta_3$');
title('Capital')
xlabel('$K$')
ylabel('$K^\prime$')

% Value function

subplot(3, 1, 2);
plot(kGrid, V1(1, :), 'b', kGrid, V1(2, :), 'r', kGrid, V1(3, :), 'g')
legend('$\theta_1$', '$\theta_2$', '$\theta_3$');
title('Value function')
xlabel('$K$')
ylabel('$V$')

% Consumption

subplot(3, 1, 3);
plot(kGrid, C(1, :), 'b', kGrid, C(2, :), 'r', kGrid, C(3, :), 'g')
legend('$\theta_1$', '$\theta_2$', '$\theta_3$');
title('Consumption')
xlabel('$K$')
ylabel('$C$')

% Simulation of optimal sequences

T = 500;

shocks = markov(theta, PI, [0, 1, 0], T + 1);

k0 = 100 * kss;

k0 = max(kGrid(kGrid <= k0));

kt = zeros(T + 1, 1);
ct = zeros(T, 1);

kt(1) = k0;
for t=1:T
    kt(t + 1) = K(shocks(t) == theta, kGrid == kt(t));
    ct(t) = C(shocks(t) == theta, kGrid == kt(t)); 
end

zt = shocks(1:T)';
it = zeros(T, 1);
yt = zeros(T, 1);
wt = zeros(T, 1);
rt = zeros(T, 1);

for t=1:T
    yt(t) = shocks(t) * A * (kt(t)^alpha);
    it(t) = kt(t + 1) - (1 - delta) * kt(t);
    wt(t) = (1 - alpha) * shocks(t) * A * (kt(t)^alpha);
    rt(t) = alpha * A * shocks(t) * kt(t)^(alpha - 1);
end

figure(2)
subplot(4, 2, 1)
plot(1:T, zt(1:T))
title('Tech Shock')

subplot(4, 2, 2)
plot(1:T, kt(1:T))
title('Capital')

subplot(4, 2, 3)
plot(1:T, yt)
title('Production')

subplot(4, 2, 4)
plot(1:T, ct)
title('Consumption')

subplot(4, 2, 5)
plot(1:T, it)
title('Investment')

subplot(4, 2, 6)
plot(1:T, wt)
title('Wages')

subplot(4, 2, 7)
plot(1:T, rt)
title('Interest Rate')

% Business Cycle Statistics

T = 500;

shocks = markov(theta, PI, [0, 1, 0], T + 1); 
k0 = kss;
k0 = max(kGrid(kGrid <= k0));
kt = zeros(T + 1, 1); 
kt(1) = k0;
ct = zeros(T, 1); 

for t = 1:T
    kt(t + 1) = K(shocks(t) == theta, kGrid == kt(t));
    ct(t) = C(shocks(t) == theta, kGrid == kt(t)); 
end

it = zeros(T, 1);
yt = zeros(T, 1);
wt = zeros(T, 1);
rt = zeros(T, 1);

for t=1:T
    yt(t) = shocks(t) * A * (kt(t)^alpha);
    it(t) = kt(t + 1) - (1 - delta) * kt(t);
    wt(t) = (1 - alpha) * shocks(t) * A * (kt(t)^alpha);
    rt(t) = alpha * A * shocks(t) * kt(t)^(alpha - 1);
end

logyt = log(yt);
logct = log(ct);
logit = log(it);
logwt = log(wt);
logrt = log(rt);

T1 = 101;

yt_std = std(logyt(T1:T));
ct_std = std(logct(T1:T));
it_std = std(logit(T1:T));
wt_std = std(logwt(T1:T));
rt_std = std(logrt(T1:T));

ct_yt_corr = corr(logyt(T1:T), logct(T1:T));
it_yt_corr = corr(logyt(T1:T), logit(T1:T));
wt_yt_corr = corr(logyt(T1:T), logwt(T1:T));
rt_yt_corr = corr(logyt(T1:T), logrt(T1:T));

disp(' ')
disp('Volatility:' )
disp(' ')

disp(['- Production    = ', num2str(yt_std)])
disp(['- Consumption   = ', num2str(ct_std)])
disp(['- Investment    = ', num2str(it_std)])
disp(['- Wages         = ', num2str(wt_std)])
disp(['- Interest Rate = ', num2str(rt_std)])

disp(' ')
disp('Production correlations: ')
disp(' ')
disp(['- Consumption   = ', num2str(ct_yt_corr)])
disp(['- Investment    = ', num2str(it_yt_corr)])
disp(['- Wages         = ', num2str(wt_yt_corr)])
disp(['- Interest Rate = ', num2str(rt_yt_corr)])
disp(' ')

% Save plots

set(get(groot, 'Children'), 'units', 'normalized', 'OuterPosition', [0.2 0.1 0.6 0.8]);

figs = findobj(allchild(0), 'flat', 'Type', 'figure');

for i = 1:length(figs)
    exportgraphics(figs(i), ['fig' num2str(length(figs) - i + 1) '.png'], 'Resolution', 500);
end
