function [x, fs] = genclick(f, d, fs)

% GENCLICK - Generates a click train
%   [X FS] = GENCLICK(F, D, FS) generates a click train of frequency F (in 
%       Hertz), duration D (in seconds) at samplig rate FS (in Hertz).

% E. Gaudrain (egaudrain@gmail.com), CNBH, PDN, University of Cambridge, UK
% 2008/02/27

n = floor(d*fs);
N = floor(n/(fs/f));
i = floor((0:N-1)*(fs/f))+1;
x = zeros(n, 1);
x(i) = 1;

%==========================================================================
%   TEST
%==========================================================================

% [x fs] = genclick(100, 1, 44100);
% t = (0:length(x)-1)/fs;
% plot(t, x);
