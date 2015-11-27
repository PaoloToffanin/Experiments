function [x fs] = generate_melody(arg1,arg2,arg3,arg4,arg5)

% GENERATE_MELODY - Builds a sound signal from a melody
%   [x fs] = generate_melody(str,fs,callback)
%       Build a melody from a melody string.
%
%   [x fs] = generate_melody(notes,durations,fs,callback)
%       Build a melody from notes and durations arrays. The notes can be
%       either a vector of frequencies, or a cell-array of note labels.
%
%       In both cases, fs is used for the sampling rate. And callback is
%       the function that produces the sound of a note. The callback
%       function can be passed as string name or handle.
%       Callback must have the following form: 
%           function x = callback(frequency,duration,fs,params)
%       Additionnal parameters can be provided to the callback function
%       invoking:
%           generate_melody(notes,durations,fs,callback,params)
%
%   Example:
%       [notes durations] = parse_melody('a3:1,a#3:1,b3:1, :1,c#4:1,g3:4');
%       notes = note_transpose(notes,4);
%       durations = durations*.5;
%       [x fs] = generate_melody(notes, durations, 44100, 'GM_puretone'); 
%       sound(x,fs)
%
%   See also NOTE_TO_FREQ, NOTE_TRANSPOSE, PARSE_MELODY, GM_PURETONE

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-18
% CNRS, Universit� Lyon 1 - UMR 5020
% $Revision: 1.2 $ $Date: 2007-07-18 13:38:54 $
%--------------------------------------------------------------------------

if nargin==3 % str,fs,callback
    [notes durations] = parse_melody(arg1);
    fs = arg2;
    callback = arg3;
    params = [];
elseif nargin==4
    if iscell(arg1) || isnumeric(arg1) % notes,durations,fs,callback
        notes = arg1;
        durations = arg2;
        fs = arg3;
        callback = arg4;
        params = [];
    else            % str,fs,callback,params
        [notes durations] = parse_melody(arg1);
        fs = arg2;
        callback = arg3;
        params = arg4;
    end
elseif nargin==5      % notes,durations,fs,callback,params
    notes = arg1;
    durations = arg2;
    fs = arg3;
    callback = arg4;
    params = arg5;
end

if isstr(callback)
    callback = str2func(callback);
end

if iscell(notes)
    notes = note_to_freq(notes);
end

% Find sounds to create
[to_create, ix, jx] = unique([notes(:) durations(:)], 'rows');
disp([int2str(length(ix)) ' sounds to build']);

% Create those sounds
sounds = {};
ii = 0;
for i=1:length(ix)
    if notes(ix(i))==-1
        sounds{i} = zeros(1,floor(fs*durations(ix(i))));
    else
        ii = ii + 1;
        params.callnumber = ii;
        sounds{i} = callback(notes(ix(i)),durations(ix(i)),fs,params);
    end
end

% Melody construction
x = [];
for i=1:length(jx)
    s = sounds{jx(i)};
    x = [x ; s(:)];
end

