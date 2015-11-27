function table=explode(sep, str)
%EXPLODE - Coupe une chaine en segments
%   ARRAY = EXPLODE(SEPARATOR, STRING)
%     Retourne un tableau de chaînes. Ce sont les sous-chaînes extraites de
%     STRING, en utilisant le séparateur SEPARATOR.
%

%------------------------------------------------
% Et. Gaudrain - 2006-03-31
% CNRS UMR-5020
% $Revision: 1.1 $ $Date: 2006-03-31 09:21:46 $
%------------------------------------------------

i=1;
rem = str;

while ~isempty(rem)
    [token, rem] = strtok(rem, sep);
    table{i} = token;
    i = i+1;
end