function out = dBglobal(in)
% DBGLOBAL - Compute a global dB value
%   OUT = dBglobal(IN)
%       IN is interpreted as a vector of octave or 1/3 octave values.
%       Each power value related to the dB value is summed.
%
%   AUTHOR
%       Nicolas Grimault
%       Etienne Gaudrain
%       Samuel Garcia
%       Laboratoire de Neurosciences et Systèmes Sensoriels,
%       UMR-CNRS 5020, 50 av. Tony Garnier, 69366 LYON Cedex 07, France


out = 10 .* log10( sum(10.^(in/10)) );