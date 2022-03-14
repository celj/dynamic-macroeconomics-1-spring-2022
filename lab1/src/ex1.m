% Dynamic macroeconomics 1 | ITAM | Spring 2022
% 1st lab problem set
% Carlos Lezama
% Plots

x = linspace(-3, 3, 1000);

figure(1);
plot(x, ceil(x), '--r', x, floor(x), '-.b', x, round(x), '-g')
title('MATLAB functions')
xlabel('$x$')
ylabel('$f(x)$')
legend('$\lceil x \rceil$', '$\lfloor x \rfloor$', 'round$(x)$')
grid on

x = linspace(0, 2 * pi, 1000);

figure(2);
subplot(2, 1, 1)
plot(x, sin(x), '--r')
title('$\sin(x)$')
axis([0, 2 * pi, -1.2, 1.2])
subplot(2, 1, 2)
plot(x, cos(x), '--b')
title('$\cos(x)$')
axis([0, 2 * pi, -1.2, 1.2])
