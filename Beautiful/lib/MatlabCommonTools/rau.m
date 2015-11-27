function x = rau(p, N)

% x = rau(p, N)
%   p: proportion(s)
%   N: number of items

% p(p==1) = 1-1/(2*N);
% p(p==0) = 1/(2*N);

T = asin(sqrt(p*N/(N+1))) + asin(sqrt((p*N+1)/(N+1)));
x = 1.46*(31.83098861*T-50)+50;