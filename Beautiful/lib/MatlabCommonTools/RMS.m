function Out = RMS(In,weight,fs)
%RMS - Root Mean Square
%   OUT = RMS(IN) 
%     - if IN is a vector, returns the root mean square value of IN.
%     - if IN is a string, it is interpreted as a wavefile filename.
%     - if IN is a string cell array, each cell is interpreted as a filename.
%	
%   OUT = RMS(IN, WEIGHT, FS)
%	weigth: return the RMS with a weighting A B or C default flat
%	fs : frequency sample (used when aeigth is not 'flat')
%
%   When IN is a vector, the RMS is always calculated along the greatest
%   dimension because sounds are supposed to be long vectors.
%
%   AUTHOR
%       N. Grimault (ngrimault@olfac.univ-lyon1.fr),
%       Et. Gaudrain (egaudrain@olfac.univ-lyon1.fr),
%       Laboratoire de Neurosciences et Systèmes Sensoriels,
%       UMR-CNRS 5020, 50 av. Tony Garnier, 69366 LYON Cedex 07, France
%	
%		Patch by Samuel Garcia sgarcia@olfac.univ-lyon1.fr
%		for the weighting

% Correction by Et. Gaudrain - 2007-02-19

if nargin < 2
	weight = 'flat';
end

if iscellstr(In)
    for i=1:length(In)
        Out{i} = RMS(In{i},weight);
    end
elseif ischar(In)
    x = wavread(In);
    Out = RMS(x,weight);
else
    if size(In,1)>size(In,2) % Vecteur colonne
        
    else
        In = In';
	end

	if strcmp(weight,'flat')
		Out = sqrt(mean(In.^2));
	else
		f = [0 (1:ceil((length(In)-1)/2))/length(In)*fs (floor((length(In)-1)/2):-1:1)/length(In)*fs ]';
		vect_dB = zeros(size(f));
		dBw = dBweighting(f, vect_dB, weight);
		IN  = fft(In);
		IN_att = IN;
		IN_att(~isnan(dBw)) = 10.^(dBw(~isnan(dBw))/20).*IN(~isnan(dBw));
		Out = sqrt(mean(ifft(IN_att).^2));
	end
		
			
	
end