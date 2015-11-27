function x = logit(p, N)

% x = logit(p, N)
%   p: proportion(s)
%   N: number of items

p(p==1) = 1-1/(2*N);
p(p==0) = 1/(2*N);

x = log(p / (1-p));