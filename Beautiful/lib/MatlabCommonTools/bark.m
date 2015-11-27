function y=bark(x)
%BARK - Gives the Bark number from a frequency
%   B = BARK(F)
%       The precise value is evaluated from a polynomial interpolation of
%       the 6th degree, on the log(F).

%-----------------------------------
% Etienne Gaudrain - 2005-06-17
% CNRS UMR-5020
%-----------------------------------


% Fedges = [0, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, 2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, 15500];
% Fc = [50, 150, 250, 350, 450, 570, 700, 840, 1000, 1170, 1370, 1600, 1850, 2150, 2500, 2900, 3400, 4000, 4800, 5800, 7000, 8500, 10500, 13500];


p=[0.0044   -0.1655    2.4818  -18.9669   78.6653 -168.8452  147.7884];
y = polyval(p,log(x));

