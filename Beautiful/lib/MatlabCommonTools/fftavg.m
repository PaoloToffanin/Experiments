function [y f] = fftavg(x,nfft,Fs,m)

%FFTAVG(X,NFFT,FS,M) - FFT moyennée sur tout le signal
%   [Y F] = FFTAVG(X,NFFT,FS)
%       La FFT est calculée autant de fois que possible
%   [Y F] = FFTAVG(X,NFFT,FS,M)
%       M représente le nombre de moyennes

%--------------------------------
% Etienne Gaudrain - 2005-07-07
% CNRS UMR-5020
%--------------------------------

% Nombre de fenêtres
n = 2*floor(length(x)/nfft);
w = [ 0 nfft/2*(1:n+1)];
f = linspace(0, Fs/2, floor(nfft/2));
y = 0;

if nargin>4
    n = min(m,n);
end

for i=1:n
    X = fft( x(w(i)+1:w(i+2)) .* hann(nfft) );
    X = X(1:floor(nfft/2));
    X = X .* conj(X) / nfft;
    y = y + X;
end

y = y/n;
