function p = mAFC_dprime_to_p(dprime, m)

% From Hacker and Ratcliff, 1979, Perception and Psychophysics

f = @(x) likelihood(x, dprime, m);
p = quadgk(f, -Inf, Inf);

%----------------------------------
function y = likelihood(x, dprime, m)

y = normpdf(x-dprime, 0, 1) .* normcdf(x, 0, 1).^(m-1);
