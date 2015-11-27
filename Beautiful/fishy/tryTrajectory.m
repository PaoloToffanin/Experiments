p0 = [2, 2];
d0 = [20, 0];
p1 = [20, 20];
d1 = -[-1, -2]*0;

nStep = 50;
t = (0:nStep)/nStep;
nRep = length(t);

p0 = repmat(p0, nRep, 1);
p1 = repmat(p1, nRep, 1);
d0 = repmat(d0, nRep, 1);
d1 = repmat(d1, nRep, 1);

a = 4;
s = ((1 - cos(2 * pi * t)) * 1/2) .^ a;

t = cumsum(s)/sum(s);
t = repmat(t', 1, 2);

P = (d1 + d0 - 2*p1 + 2*p0) .* t.^3 + ...
    (3 * p1 - 2 * d0 - d1 - 3 * p0) .* t.^2 + ...
    d0 .* t + ...
    p0;



% subplot(1,3,1)
plot(P(:, 1), P(:, 2), 'k-+')
hold on
% subplot(1,3,2)
v0 = [p0; p0+d0];
plot(v0(:, 1), v0(:, 2))
% subplot(1,3,3)
v1 = [p1; p1+d1];
plot(v1(:, 1), v1(:, 2))


hold off