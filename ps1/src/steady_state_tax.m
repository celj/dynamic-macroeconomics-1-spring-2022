% Dynamic macroeconomics 1 | ITAM | Spring 2022
% 1st problem set
% Carlos Lezama
% Steady state of the Neoclassical growth model with income tax

global alpha beta delta A T tau

% equations
ss = @(css, kss) [(1 / beta) - ((1 - tau) * (alpha * A * kss ^ (alpha - 1))) - (1 - delta);
                  ((1 - tau) * (A * kss ^ alpha)) - css - (delta * kss)];

temp = @(x) ss(x(1), x(2));
guess = [100; 100];

ss_solution = fsolve(temp, guess);

% steady state
css = ss_solution(1);
kss = ss_solution(2);
yss = A * kss ^ alpha;
wss = (1 - alpha) * yss;
rss = (alpha / kss) * yss;

% time
T = 100;
