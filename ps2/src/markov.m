function [X_path, state] = markov(x, P, pi0, T)

n = length(x);
E = rand(T,1); 

cumsumP = P * triu(ones(size(P)));
E0   = rand(1, 1); 
ppi0 = [0, cumsum(pi0)]; 
s0   = ((E0 <= ppi0(2:n + 1)) .* (E0 > ppi0(1:n)))'; 
s    = s0;                                   

for t=1:T
    state(:, t) = s;
    ppi        = [0, s' * cumsumP]; 
    s          = ((E(t) <= ppi(2:n + 1)) .* (E(t) > ppi(1:n)))';
end

X_path = x * state;    
