function [x Fs t] = gensin(f,dur,dph,Fs)

% GENSIN - Generates a sinusoidal signal
%   X = GENSIN(F)
%       Produces a one second sinusoidal signal, at frequency F, and at
%       sampling frequency 44100 Hz.
%
%   X = GENSIN(F,DUR)
%       Specify duration DUR in seconds.
%
%   X = GENSIN(F,DUR,DPH)
%       Specify phase delay DPH in radians.
%
%   X = GENSIN(F,DUR,DPH,FS)
%       Specify sampling frequency FS in Hertz.
%
%   [X FS] = GENSIN(...)
%       Returns signal X and sampling frequency FS.
%
%   [X FS T] = GENSIN(...)
%       Returns temporal vector T in addition.
%
%   GENSIN(...)
%       Without output, GENSIN plays the sound.

%----------------------------
% Et. Gaudrain - 2005-05-28
% CNRS UMR-5020
%----------------------------

if nargin<2
    dur = 1;
end
if nargin<3
    dph = 0;
end
if nargin<4
    Fs = 44100;
end

t = (0:(dur*Fs-1))/Fs;
x = sin(2*pi*f*t+dph);

if nargout==0
    disp('Sound...');
    sound(0.98*x,Fs);
end

