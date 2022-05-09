function [grid, P] = tauchen(rho, N, sigma)
sigma_z = sqrt(sigma^2 / (1 - rho^2)); 
step =(2 * sigma_z * 3)/(N - 1);
grid = zeros(N, 1);
for i = 1:N
    grid(i) = -3 * sigma_z + (i - 1) * step;
end

P = zeros(N, N);
if N > 1 
   for i = 1:N
    P(i, 1) = normcdf((grid(1) + step / 2 - rho * grid(i)) / sigma);
    P(i, N) = 1 - normcdf((grid(N) - step / 2 - rho * grid(i)) / sigma);
        for j = 2:N - 1
        P(i, j) = normcdf((grid(j) + step / 2 - rho * grid(i)) / sigma) ...
                - normcdf((grid(j) - step / 2 - rho * grid(i)) / sigma);
        end
   end
else
    P = 1;
end      
end
