%
%   normalise_wave_rms_dir(name,exten)
%
%   In :
%
%    - name : *.* pour tout lister
%    - exten : extention ajjouter au nom
%
%  out :
%
%%%%%%%%%%%%%%
%
% Normalise tout les fichiers d'un repertoire en rms.
% Exemple : cd rep; normalise_wave_rms('*.wave','_new');
% normalise tout les fichiers wave du repertoire et les sauve avec
% l'extention _new
%
%%%%%%%%%%%%%%
% sgarcia@olfac.univ-lyon.fr

function normalise_wave_rms_dir(name,exten,type)

if nargin<3
	type = 'flat';
end

list = dir(name);
if length(list)==0
	return
end
% on lit tout
for i=1:length(list)
	list(i).name
	[y,Fs,bits] = wavread(list(i).name);
	list(i).pic = max(abs(y));
	%list(i).rms = sqrt(mean(y.^2));
	list(i).rms = RMS(y,type,Fs);
end
pic = [ list.pic ];
rms = [ list.rms ];
max_pic = max(pic./rms);

% on reecrit
for i=1:length(list)
	list(i).name
	[y,Fs,bits] = wavread(list(i).name);
	y_out = y/list(i).rms/max_pic*0.95;
	[pathstr,name,ext,versn] = fileparts(list(i).name);
	wavwrite(y_out,Fs,bits,[name exten ext]);
end

