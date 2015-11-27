function ajoute_rampe_wave(nom,t_debut,t_fin)
% lit un fichier ajoute une rampe lineaire au debut et à la fin
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
nom

[sig Fs bits] = wavread(nom);

for i=1:size(sig,2)
	sig(1:round(t_debut*Fs),i) = sig(1:round(t_debut*Fs),i) .* (0:round(t_debut*Fs)-1)'/(t_debut*Fs);
	sig(end-round(t_fin*Fs)+1:end,i) = sig(end-round(t_fin*Fs)+1:end,i) .* ...
		fliplr(0:round(t_fin*Fs)-1)'/(t_fin*Fs);
end

wavwrite(sig,Fs,bits,nom);

