function i = randpick(v, avoid)

i = v(randi(length(v)));

if nargin==2
    if all(v==avoid)
        error('All values are equal to the one to avoid...');
    end
    while i==avoid
        i = v(randint(length(v)));
    end
end