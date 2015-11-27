function sig_modif=GenereEnveloppeBruit(nomfichier,prefixe, nomfichierbruit);
% sig=GenereEnveloppeBruit(nomfichier,extention);
% transforme un fichier son en prenant son enveloppe temporelle
% remplie d'un bruit coloré de même spectre que le signal d'origine
%------------------------------------------------
% In:
%   - nomfichier : nom du fichier
%   - extention : extention ajouter en début du nouveau fichier généré
%		   (defau 'e_')
%   - nom dufichier : genere (facultatif)
% Out:
%   - sig_modif : signal modifié
%------------------------------------------------
% nicolas Grimault - 2006-03-31
% CNRS UMR-5020
% $Revision: 1.1 $ $Date: 2006-04-07 12:26:17 $
%------------------------------------------------

if nargin <2
    prefixe = 'e_';
end
if nargin <3
    [pathstr, name, ext, versn] = fileparts(nomfichier);
    nomfichierbruit = fullfile(pathstr,[prefixe name ext]);
end


[sig fe bit]=wavread(nomfichier);%lit le signal a transformer (dans un fichier wav)
rmssig=sqrt(sum(sig(:,1).^2)/length(sig(:,1)));%energie RMS du signal
[Fparam1 Fparam2]=butter(1, 60/(0.5*fe));%filtre passe bas pour extraire l'enveloppe temporelle du signal Fc=60 Hz
LPsig=filter(Fparam1,Fparam2,abs(sig(:,1)));%enveloppe temporelle du signal (redressée)
phasefftnoise=2*pi*rand(length(sig),1);%génération de phases aléatoires
fftsig=abs(fft(sig(:,1)));%module de la fft du signal
fftnew=fftsig.*exp(-j*phasefftnoise);%calcul de la fft du signal transformé en utilisant comme module celui du signal d'origine 
                                     %et les phases aléatoires
new=real(ifft(fftnew));%calcul du signal transformé par FFT-1
new=new.*LPsig;%on applique l'enveloppe temporelle du signal d'origine au signal transformé
rmsnewsig=sqrt(sum(new.^2)/length(new));%energie RMS du signal transformée
sig_modif=rmssig*new/rmsnewsig;%ajustement de l'énergie du nouveau signal à l'ancien


if max(abs(new))>1 | max(abs(sig(:,1)))>1 %vérifie qu'il n'y a pas saturation
    disp('Error: saturation...');
    disp(['Maximum = ' int2str(max(abs(new)))]);
end

wavwrite(sig_modif,fe,bit,nomfichierbruit);


