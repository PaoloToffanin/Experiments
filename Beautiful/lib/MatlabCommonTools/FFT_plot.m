function [f, Pyy]=FFT_plot(x,fs,n,range,color,flag,smooth)
%FFT_PLOT - Plots the FFT of a signal
%   FFT_PLOT(X,FS) Plots the FFT of X assuming a sampling frequency FS.
%   FFT_PLOT(X,FS,N) Plots the FFT of X with N points, assuming that the
%       sampling frequency is FS.
%   FFT_PLOT(X,FS,N,RANGE) Plots only over the frequency intervalle RANGE,
%      a vector of two frequencies in Hertz.
%   FFT_PLOT(X,FS,N,RANGE,COLOR) Plots with the color COLOR. COLOR can be a
%      Linespec.
%   FFT_PLOT(X,FS,N,RANGE,COLOR,FLAG) If FLAG is 1 or 'log', the FFT is
%      plotted as dB power.
%   FFT_PLOT(X,FS,N,RANGE,COLOR,FLAG,SMOOTH) Plots the FFT smoothed
%      (convolved) with the SMOOTH vector.
%   [F, Pxx] = FFT_PLOT(...) Doesn't plot the FFT but return the frequency
%      vector and the power spectrum Pxx. Use plot(F,Pxx) to display it.
%
%   Author :
%       Etienne Gaudrain
%       UMR-CNRS 5020 Neurosciences et Systèmes Sensoriels
%
%   Date :
%       2005-03-29

% CHANGES :
% 2004-08-19 : EtG
%   If output args, no plot
% 2005-03-29 : EtG
%   If no length, use the total vector length

if nargin<2
    error('FFT_plot needs at least 2 arguments : the data, and the sampling frequency...');
end

if nargin==2
    n = length(x);
end

disp(['Nombre de points :',int2str(n)]);

Y = fft(x, n);

Pyy = Y.*conj(Y)/n;

f = fs * (0:floor(n/2))/n;

Pyy = Pyy(1:(floor(n/2)+1));

if nargin>=4 & ~isempty(range)
    Pyy = Pyy(f>=range(1) & f<=range(2)); 
    f   =   f(f>=range(1) & f<=range(2));
end

if nargin<6 || isempty(flag)
    flag = 0;
end

if nargin>=7 & length(smooth)>1
    tmp = conv(Pyy, smooth);
    tmp = tmp(ceil(length(smooth)/2):(ceil(length(smooth)/2)+length(Pyy')-1));
    Pyy = tmp;
    clear tmp;
end

if flag==1 | flag=='log'
    Pyy = 10 * log10(Pyy);
elseif flag~=0
    warning('The flag parameter must be either 0, 1 or ''log''... Set to default 0');
end

if nargout==0 % No output then plot
	if nargin>=5 & ~isempty(color)
        plot(f, Pyy, color);
	else
        plot(f, Pyy);
	end
    
    xlabel('Frequence (Hz)');
	ylabel('Amplitude');
	
	grid on
	box on
end


