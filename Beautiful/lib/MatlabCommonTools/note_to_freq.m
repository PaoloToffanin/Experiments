function freq = note_to_freq(notes)

% NOTE_TO_FREQ - Convert international notation to frequency
%   freq = note_to_freq(notes)
%       Returns a vector of frequencies from the cell array of notes.
%       Example: f = note_to_freq({'a3', 'c#4', 'bb2'})
%
%   See also NOTE_TRANSPOSE, PARSE_MELODY

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-17
% CNRS, Universit� Lyon 1 - UMR 5020
% $Revision: 1.1 $ $Date: 2007-07-18 12:33:49 $
%--------------------------------------------------------------------------

semitones.c = 0;
semitones.d = 2;
semitones.e = 4;
semitones.f = 5;
semitones.g = 7;
semitones.a = 9;
semitones.b = 11;
alter.('d') = 1;
alter.('b') = -1;
alter.('e') = 0;

a4_frequency = 440;
c0_frequency = a4_frequency * 2^(-57/12);

freq = [];
for i=1:length(notes)
    note = regexp(notes{i},'([a-gA-G])([#b]?)([0-9]+)','tokens');
    
    if length(note)<1
        freq = [freq -1];
        continue
    else
        note = note{1};
        if strcmp(note{2},'')==1
            note{2} = 'e';
        elseif strcmp(note{2},'#')==1
            note{2} = 'd';
        end
        freq = [freq c0_frequency*2^((semitones.(lower(note{1})) + alter.(note{2}) + str2num(note{3})*12)/12)];
    end
end
    
