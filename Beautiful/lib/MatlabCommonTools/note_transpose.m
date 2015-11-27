function freq = note_transpose(notes, semitones)

% NOTE_TRANSPOSE - Transpose notes and return frequencies
%   freq = note_transpose(notes, semitones)
%       notes can be a vector of frequencies or a cell-array of notes.
%
%   See also NOTE_TO_FREQ

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-17
% CNRS, Universit� Lyon 1 - UMR 5020
% $Revision: 1.1 $ $Date: 2007-07-18 12:33:49 $
%--------------------------------------------------------------------------

if iscell(notes)
    notes = note_to_freq(notes);
end

freq = notes;
freq(notes ~= -1) = notes(notes ~= -1) * 2^(semitones/12);