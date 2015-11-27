function [notes durations] = parse_melody(str)

% PARSE_MELODY - Parses a melody string
%   [notes durations] = parse_melody(str)
%       Each note is separated by a comma in str. Here is an example for
%       the melody notation: 'a3:1,c#4:2,eb4:4.5, :2.5'. Space stand for
%       silence and duration is given in whatever unit (quarter note for
%       example). You then have to multiply the durations by the actual
%       value in seconds.
%
%   See also NOTE_TO_FREQ NOTE_TRANSPOSE

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-18
% CNRS, Université Lyon 1 - UMR 5020
% $Revision: 1.1 $ $Date: 2007-07-18 12:33:49 $
%--------------------------------------------------------------------------

melody = explode(',',str);

notes = {};
durations = [];

for i=1:length(melody)
    note = explode(':',melody{i});
    durations(i) = str2num(note{2});
    notes{i} = strtrim(note{1});
end
    
    