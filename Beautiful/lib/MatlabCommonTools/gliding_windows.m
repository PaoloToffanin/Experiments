function y = gliding_windows(x, win, callback, params)

if isstr(callback)
    callback = str2func(callback);
end

Sx = size(x);

if min(Sx)>1
    error('The gliding function only works on vectors');
end

Lx = length(x);
Lw = length(win);

if rem(Lw, 2)~=1
    error(['The length of the window should be odd (is ' int2str(Lw) ')']);
end

Nw = ceil( (Lx-1) / ((Lw-1)/2) );

y = zeros(Nw*(Lw-1)/2+(Lw+1)/2, 1);
x = [x(:) ; zeros(length(y)-Lx, 1)];

params.iteration = 0;
y(1:(Lw+1)/2) = callback(x(1:(Lw+1)/2) .* win((Lw+1)/2:end), params);

for i=1:Nw
    i1 = (Lw-1)/2*(i-1) + 1;
    i2 = i1 + Lw - 1;
    
    params.iteration = i;
    y(i1:i2) = y(i1:i2) + callback(x(i1:i2) .* win, params);
end

params.iteration = i+1;
y(end-(Lw+1)/2+1:end) = y(end-(Lw+1)/2+1:end) + callback(x(end-(Lw+1)/2+1:end).* win(1:(Lw+1)/2), params);

y = y(1:Lx);

if Sx(1)<Sx(2)
    y = y';
end
    