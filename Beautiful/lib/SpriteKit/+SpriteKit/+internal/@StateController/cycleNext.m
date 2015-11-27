function cycleNext(obj)
%CYCLENEXT Set State forward to next in queue.
%
% See also CYCLEPREVIOUS, INITSTATE.

% Copyright 2014 The MathWorks, Inc.

obj.State = obj.Index2State{obj.CurrentIndex+1};