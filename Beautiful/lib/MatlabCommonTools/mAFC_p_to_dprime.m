function dprime = mAFC_p_to_dprime(p, m)

% Smith, 1982, Perception and Psychophysics

if p==0
    dprime = -Inf;
elseif p==1
    dprime = +Inf;
elseif p<0 || p>1
    error(sprintf('Probability must be between 0 and 1 (%f given).', p));
else
    f = @(x) abs(mAFC_dprime_to_p(x, m)-p);
    x0 = (0.86-0.085*log(m-1)) * log((m-1)*p/(1-p));
    dprime = fminsearch(f, x0);
end