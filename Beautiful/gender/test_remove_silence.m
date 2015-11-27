[x, fs] = wavread('/Users/denizbaskent/Sounds/NVA/equalized/Baai.wav');

x = x(:,1);

subplot(2,1,1)
plot(x)

y = remove_silence(x,fs);

subplot(2,1,2)
plot(y)