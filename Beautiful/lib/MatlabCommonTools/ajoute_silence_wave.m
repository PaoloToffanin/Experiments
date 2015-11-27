function ajoute_silence_wave(nom,t_debut,t_fin)
% lit un fichier ajoute un silence au debut et ? la fin
% et le sauve dans le meme nom
% In :
%	- nom : nom du fichier
%	- t_debut : temps de la rampe au debut (s)
%	- t_fin : temps de la rampe a la fin (s)
%
%
%	Samuel GARCIA
%	CNRS  NSS
%   sgarcia@olfac.univ-lyon.fr
%
%   05.2005
%
% see also


[sig Fs bits] = wavread(nom);

sig = [ zeros(round(Fs*t_debut),size(sig,2))  ; ...
       sig ; ...
        zeros(round(Fs*t_fin),size(sig,2)) ];


wavwrite(sig,Fs,bits,nom);