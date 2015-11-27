function initState(obj,stateKey,stateValue)
%INITSTATE Initialize State with unique Key to associated value.
% When initializing states, order is preserved in the queue, to be used
% with the CYCLENEXT/CYCLEPREVIOUS methods.
%
% The StateController always has a 'none' State, which can not be
% overwritten. The user can overwrite a previously defined state, which
% will simply replace the values and retain the same queue index.
%
% Example:
%  INITSTATE(OBJ,KEY,VALUE)
%
% See also CYCLENEXT, CYCLEPREVIOUS, STATE.

% Copyright 2014 The MathWorks, Inc.

if ~ischar(stateKey)
    error('State names must be strings')
end
if strcmp(stateKey,'none')
    error('The ''none'' State can not be overwritten')
end

if ~isKey(obj.State2Value,stateKey)
    % new key: append to the end of the queue
    obj.Index2State{end+1} = stateKey;
end

% will either overwrite existing key-value or append
obj.State2Value(stateKey) = stateValue;
