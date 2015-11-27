function cyclePrevious(obj)
%CYCLEPREVIOUS Set State backward to previous in queue.
%
% See also CYCLEFORWARD, INITSTATE.

% Copyright 2014 The MathWorks, Inc.

obj.State = obj.Index2State{obj.CurrentIndex-1};