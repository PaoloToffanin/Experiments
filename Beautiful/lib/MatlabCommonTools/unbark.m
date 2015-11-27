function x=unbark(y)
%BARK - Gives the frequency from a Bark number
%   F = UNBARK(B)
%       The precise value is evaluated from a polynomial interpolation of
%       the 6th degree, on the exp(B).

%-----------------------------------
% Etienne Gaudrain - 2005-06-17
% CNRS UMR-5020
%-----------------------------------


% Fedges = [0, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, 2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, 15500];
% Fc = [50, 150, 250, 350, 450, 570, 700, 840, 1000, 1170, 1370, 1600, 1850, 2150, 2500, 2900, 3400, 4000, 4800, 5800, 7000, 8500, 10500, 13500];

% x = linspace(30,15000,200);
% y = bark(x); 
% plot(y,x,'b')
% hold on

% p=[-0.0000    0.0001   -0.0021    0.0375   -0.3560    1.8607    2.2355];
p = [0.0002   -0.0017   -0.1338    4.0231  -35.0056  212.5824 -154.5357];
% p = polyfit(y,x,6)

% y = 1:25;
x = polyval(p,y);

% plot(y,x,'-r')
% hold off

