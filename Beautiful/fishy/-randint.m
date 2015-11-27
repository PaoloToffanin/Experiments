function i = randint(n)

if n==0
    i=0;
else
    if ~exist('randi', 'builtin')
        v = randperm(n);
        i = v(1);
    else
        i = randi(n);
    end
end