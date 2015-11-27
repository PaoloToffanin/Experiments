function x = GM_puretone(frequency,duration,fs,params)

% GM_PURETONE - A simple pure tone callback function for generate_melody

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-18
% CNRS, Universit� Lyon 1 - UMR 5020
% $Revision: 1.1 $ $Date: 2007-07-18 12:33:49 $
%--------------------------------------------------------------------------

t = (0:floor(fs*duration)-1)/fs;
x = 0.7*cosgate(sin(2*pi*frequency*t),fs,10e-3);