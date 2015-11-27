function dBw = dBweighting(f, dB, weight, method)
%DBWEIGHTING - ANSI dB WEIGHTING
%   dBW = DBWEIGHTING(F, dB) returns the X with a A weighting. F must be the
%   row of frequencies, and X the row of dB data. The exact weighting is
%   calculated by linear interpolation from the ANSI data. The available
%   frequency range is 10Hz-20kHz.
%
%   dBW = DBWEIGHTING(F, dB, WEIGHT) specifies the weighting. Available values
%   for WEIGHT are :
%        'A' - for low levels (~50dB)
%       '-A' - inverse A weighting
%        'B' - for medium levels
%       '-B' - inverse B weighting
%        'C' - for loud levels (over 95dB)
%       '-C' - inverse C weighting
%   Use the inverse weightings to convert data from a specific weighting to
%   flat.
%
%   dBW = DBWEIGHTING(F, dB, WEIGHT, METHOD) specifies the
%   interpolation method. The avalaible values are the same than for the
%   INTERP1 function : 'nearest', 'linear', 'spline', 'pchip' and 'cubic'.
%
%   For example, to convert some flat dB data to dBB with spline precision :
%       dB = [75.6, 87.2, 72]; f = [102, 1369, 18569];
%       dBw = dBweighting(f, dB, 'B', 'spline');
%
%   REFERENCES
%       ANSI S1.6-1967 (R1976).
%
%   AUTHOR
%       Et. Gaudrain (egaudrain@olfac.univ-lyon1.fr),
%       Laboratoire de Neurosciences et Systèmes Sensoriels,
%       UMR-CNRS 5020, 50 av. Tony Garnier, 69366 LYON Cedex 07, France       

if nargin<3
    weight = 'A';
end
if nargin<4
    method = 'linear';
end

% ANSI nominal frequencies (ANSI S1.6-1967 [R1976])
F_ANSI = [10, 12.5, 16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000];
% Exact frequencies, just for fun...
% F = 10.^(0.1 * (10:43));

% ANSI weighting
A = [-70.4, -63.4, -56.7, -50.5, -44.7, -39.4, -34.6, -30.2, -26.2, -22.5, -19.1, -16.1, -13.4, -10.9, -8.6, -6.6, -4.8, -3.2, -1.9, -0.8, 0, 0.6, 1.0, 1.2, 1.3, 1.2, 1.0, 0.5, -0.1, -1.1, -2.5, -4.3, -6.6, -9.3];
B = [-38.2, -33.2, -28.5, -24.2, -20.4, -17.1, -14.2, -11.6, -9.3, -7.4, -5.6, -4.2, -3.0, -2.0, -1.3, -0.8, -0.5, -0.3, -0.1, 0, 0, 0, 0, -0.1, -0.2, -0.4, -0.7, -1.2, -1.9, -2.9, -4.3, -6.1, -8.4, -11.1];
C = [-14.3, -11.2, -8.5, -6.2, -4.4, -3.0, -2.0, -1.3, -0.8, -0.5, -0.3, -0.2, -0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.1, -0.2, -0.3, -0.5, -0.8, -1.3, -2.0, -3.0, -4.4, -6.2, -8.5, -11.2];

switch weight
    case 'A'
        w = A;
    case '-A'
        w = -A;
    case 'B'
        w = B;
    case '-B'
        w = -B;
    case 'C'
        w = C;
    case '-C'
        w = -C;
    otherwise
        error('"%s" is not a valid weighting. Please use "A", "-A", "B", "-B", "C" or "-C"', weight);
end

if(weight == 'A' & max(dB)>71)
    warning('The A weighting is only for low levels (~50dB). Over 70dB you should use the B weighting.');
end

% dB and f must be column vectors
% >> EtG. - 06 july 2004 - Interpolation is now on power instead of decibels
dBw = 10 * log10(interp1(log10(F_ANSI), 10.^(w/10), log10(f), method)) + dB;
