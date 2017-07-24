cf = 2000;                  % carrier frequency (Hz)
sf = 44100;                 % sample frequency (Hz)
d = 30.0;                    % duration (s)
n = sf * d;                 % number of samples
% s = (1:n) / sf;             % sound data preparation
% s = 1.5 * sin(2 * pi * cf * s);   % sinusoidal modulation
% % make noise
% noise = randn(1, n);             % Gausian noise
% noise = noise / max(abs(noise)); % -1 to 1 normalization
% noise = 4 * noise; % -1 to 1 normalization

% set variables for filter
lf = 20;   % lowest frequency
hf = 20000;   % highest frequency
lp = lf * d; % ls point in frequency domain    
hp = hf * d; % hf point in frequency domain
% while 1
%     clc;
%     v = input('lowpass(1), highpass(2), bandpass(3), notch(4) ? ');
%     if v >= 1 & v <= 4;
%         break
%     end
% end
v = 3;
% design filter
% clc;
switch v
    case 1
    a = ['LOWPASS'];
    filter = zeros(1, n);           % initializaiton by 0
    filter(1, 1 : lp) = 1;          % filter design in real number
    filter(1, n - lp : n) = 1;      % filter design in imaginary number
    case 2        
    a = ['HIGHPASS'];
    filter = ones(1, n);            % initializaiton by 1
    filter(1, 1 : hp) = 0;          % filter design in real number
    filter(1, n - hp : n) = 0;      % filter design in imaginary number
    case 3
    a = ['BANDPASS'];
    filter = zeros(1, n);           % initializaiton by 0
    filter(1, lp : hp) = 1;         % filter design in real number
    filter(1, n - hp : n - lp) = 1; % filter design in imaginary number
    case 4
    a = ['NOTCH'];
    filter = ones(1, n);
    filter(1, lp : hp) = 0;
    filter(1, n - hp : n - lp) = 0;
end

% =========================================================================
% make noise
noise = randn(1, n);             % Gausian noise
noise = noise / max(abs(noise)); % -1 to 1 normalization

% do filter
s = fft(noise);                  % FFT
s = s .* filter;                 % filtering
s = ifft(s);                     % inverse FFT
s = real(s);
% =========================================================================
% play noise
% disp('WHITE noise');
% sound(noise, sf);                % playing sound



% s = noise;
% plot(noise)

s = 4 * s;
% prepare ramp
dr = d / 10;
nr = floor(sf * dr);
r = sin(linspace(0, pi/2, nr));
r = [r, ones(1, n - nr * 2), fliplr(r)];

% make ramped sound
s = s .* r;
sound(s, sf);               % sound presentation
% pause(d + 0.5);             % waiting for sound end
% plot(s);

