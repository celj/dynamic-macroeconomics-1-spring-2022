% Dynamic macroeconomics 1 | ITAM | Spring 2022
% 1st problem set
% Carlos Lezama
% Sequential Neoclassical growth model

% No distortions
global alpha beta delta A k0 T tau

alpha = 0.35;
beta = 0.99;
delta = 0.06;
A = 10;

steady_state;

k0 = kss / 2;

initC = repelem(css, T)';
initK = repelem(kss, T - 1)';
init = [initC; initK];

transition_solution = fsolve(@(x) transition(x), init, options);

c = transition_solution(1:T);
k = [k0; transition_solution((T + 1):(2 * T - 1))];
y = A .* k .^ alpha;
w = (1 - alpha) .* y;
r = (alpha ./ k) .* y;

figure;

subplot(3,2,1)
plot(1:T, k)
title('Capital')
xlabel('$t$')
ylabel('$k_t$')

subplot(3,2,2)
plot(1:T, c)
title('Consumption')
xlabel('$t$')
ylabel('$c_t$')

subplot(3,2,3)
plot(1:T, y)
title('Production')
xlabel('$t$')
ylabel('$y_t$')

subplot(3,2,4)
plot(1:T, w)
title('Real wage')
xlabel('$t$')
ylabel('$w_t$')

subplot(3,2,5)
plot(1:T, r)
title('Interest rate')
xlabel('$t$')
ylabel('$r_t$')

% First income tax

tau = 0.2;

steady_state_tax;

k0 = kss / 2;

initC = repelem(css, T)';
initK = repelem(kss, T - 1)';
init = [initC; initK];

transition_solution = fsolve(@(x) transition_tax(x), init, options);

c = transition_solution(1:T);
k = [k0; transition_solution((T + 1):(2 * T - 1))];
y = A .* k .^ alpha;
w = (1 - alpha) .* y;
r = (alpha ./ k) .* y;

figure;

subplot(3,2,1)
plot(1:T, k)
title('Capital')
xlabel('$t$')
ylabel('$k_t$')

subplot(3,2,2)
plot(1:T, c)
title('Consumption')
xlabel('$t$')
ylabel('$c_t$')

subplot(3,2,3)
plot(1:T, y)
title('Production')
xlabel('$t$')
ylabel('$y_t$')

subplot(3,2,4)
plot(1:T, w)
title('Real wage')
xlabel('$t$')
ylabel('$w_t$')

subplot(3,2,5)
plot(1:T, r)
title('Interest rate')
xlabel('$t$')
ylabel('$r_t$')

% Second income tax

tau = 0.25;

steady_state_tax;

k0 = kss / 2;

initC = repelem(css, T)';
initK = repelem(kss, T - 1)';
init = [initC; initK];

transition_solution = fsolve(@(x) transition_tax(x), init, options);

c = transition_solution(1:T);
k = [k0; transition_solution((T + 1):(2 * T - 1))];
y = A .* k .^ alpha;
w = (1 - alpha) .* y;
r = (alpha ./ k) .* y;

figure;

subplot(3,2,1)
plot(1:T, k)
title('Capital')
xlabel('$t$')
ylabel('$k_t$')

subplot(3,2,2)
plot(1:T, c)
title('Consumption')
xlabel('$t$')
ylabel('$c_t$')

subplot(3,2,3)
plot(1:T, y)
title('Production')
xlabel('$t$')
ylabel('$y_t$')

subplot(3,2,4)
plot(1:T, w)
title('Real wage')
xlabel('$t$')
ylabel('$w_t$')

subplot(3,2,5)
plot(1:T, r)
title('Interest rate')
xlabel('$t$')
ylabel('$r_t$')
