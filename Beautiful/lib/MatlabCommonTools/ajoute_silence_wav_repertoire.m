function ajoute_silence_repertoire
% ajoute une rampe lineaire sur tous les fichiers wav d'un repertoire
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
% see also ajoute_rampe_wave


rep = uigetdir('','choisir le repertoire');;

liste = dir(fullfile(rep,'*.wav'));

titre = 'Choisir le temps rampe en s';
listParamDef = { '0.001' '0.001' };
listExpl = {'au debut' 'a la fin' };
reponse = inputdlg(listExpl,titre,1,listParamDef);
if length(reponse)==0
	return
end

t_debut = str2num(reponse{1});
t_fin = str2num(reponse{2});


for i=1:length(liste)
	ajoute_silence_wave(fullfile(rep,liste(i).name),t_debut,t_fin);
end

