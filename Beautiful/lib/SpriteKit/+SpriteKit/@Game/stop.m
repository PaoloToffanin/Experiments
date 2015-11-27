function stop(obj)
%STOP Stops gameplay.
% STOP(GAME) can be issued inside of the ACTION function handle that is
% passed to PLAY when a certain condition is met (gameover, scene
% transitions, etc).
%
% See also PLAY.

% Copyright 2014 The MathWorks, Inc.

if ~obj.isPlaying
    warning('STOP should only be called within a PLAY function');
else
    obj.StopFlag = true;
end