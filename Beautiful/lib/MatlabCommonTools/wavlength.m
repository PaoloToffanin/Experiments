function len = wavlength(filename)
% WAVLENGTH(FILENAME)
%   Displays length in seconds.

%----------------
% Etienne Gaudrain - CNRS UMR-5020
% 2005-05-20
%----------------

[x fs] = wavread(filename);
len = length(x)/fs;