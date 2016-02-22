function x = frq2x(frq)
% MM = FRQ2MM(FRQ)
% 	Applies Greenwood's function for mapping frequency to place
%   on the basilar membrane.
%   
%   See Greenwood D.D. (1990) JASA 87, 6:2592?2605. doi:10.1121/1.399052.

% Etienne Gaudrain <e.p.c.gaudrain@umcg.nl> - 2013-09-11
% University Medical Center Groningen, NL

% Copyright UMCG, Etienne Gaudrain, 2013
% This is code is distributed with no warranty under GNU General Public
% License v3.0. See http://www.gnu.org/licenses/gpl-3.0.txt for the full
% text.

a= 2.1; % appropriate for locations given as a ratio
A= 165.4;
k = 0.88;

x = (1/a) * log10(frq/A + k); %x is given as a ratio





