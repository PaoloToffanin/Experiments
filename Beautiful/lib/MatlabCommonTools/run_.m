function run(scriptname)

% RUN - Runs an arbitrary script providing its full filename
%   Example: run('../../scripts/setParameters.m')

f = fopen(scriptname, 'r');
m = char(fread(f))';
fclose(f);

evalin('caller', m)