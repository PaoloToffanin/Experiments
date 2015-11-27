function h = plotwav(filename,LineSpec)

%PLOTWAV - plots a wav file
%   PLOTWAV(FILENAME)
%       Simply plots the wav file with default LineSpec.
%
%   PLOTWAV(FILENAME,LINESPEC)
%       Plots the wav file with LINESPEC.
%
%   H = PLOTWAV(...)
%       Returns the handle of the returned by the plot function used to
%       plot the wav file.

% Et. Gaudrain - 2005-07-01
% CNRS UMR-5020 - France

[x fs] = wavread(filename);
t = (0:length(x)-1)/fs;

if nargout == 1
    if nargin>1
        h = plot(t,x,LineSpec);
    else
        h = plot(t,x);
    end
else
    if nargin>1
        plot(t,x,LineSpec);
    else
        plot(t,x);
    end
end

xlim([0 t(end)]);
xlabel('Time (s)');
ylabel('Magnitude');