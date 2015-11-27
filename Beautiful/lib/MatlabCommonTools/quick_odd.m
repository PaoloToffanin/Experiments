function quick_odd(f1, f2)

f = {f1, f2};

j = randperm(2);

[x{1}, fs] = wavread(f{j(1)});
[x{2}, fs] = wavread(f{j(2)});

i = [1, randperm(2)];

for k=i
    wavplay(x{k}, fs);
    pause(.5)
end

r = input('Which one is different (2 or 3)? ', 's');
r = str2double(r);
if r==find(i==2)
    disp('Correct!');
else
    disp('Wrong!');
end

