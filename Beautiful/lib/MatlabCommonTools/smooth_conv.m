function y = smooth_conv(x, w)


y = [repmat(x(1), length(w), 1) ; x(:) ; repmat(x(end), length(w), 1)];
y = conv(y, w);
y = y(ceil(3*length(w)/2) : end-floor(3*length(w)/2));
y = max(y, 0) / max(y) * max(x);
