function play(obj,action,fps)
%PLAY Begin Game action.
%
% PLAY(GAME,ACTION) plays GAME, looping continuously over the function
% handle ACTION until a STOP is issued.
%
% PLAY(...,FPS) optionally specifies a desired number of Frames-per-Second
% (FPS). The default is 60.
%
% Example:
%
%   % Start with a Game and Sprite:
%   G = SpriteKit.Game.instance;
%   mySprite = SpriteKit.Sprite('foo');
%   mySprite.initState('on','demo/seasons/spring.png');
%   mySprite.State = 'on';
%
%   % Define a function to move the sprite to right each time:
%   function action(s)
%       s.Location = s.Location+[1 0];
%   end
%
%   % Then call play:
%   PLAY(G, @()action(mySprite))
%
% See also STOP.

% Copyright 2014 The MathWorks, Inc.


if ~isa(action,'function_handle')
    error('''ACTION'' must be a function handle')
end

if nargin==3
    if ~(isscalar(fps) && isnumeric(fps))
        error('''FPS'' must be scalar numeric if specified')
    end
else
    fps = 60; % default
end

maxframerate = 1/fps;
FPSupdateRate = 10;
count = 0;
obj.isPlaying = true;

try
    
    while true
        
        tic;
        count = count+1;
        
        % call action
        action();
        
        % update view
        drawnow;
        
        % throttle framerate
        buffer(maxframerate)
        
        if obj.ShowFPS && mod(count,FPSupdateRate)==0
            % update FPS reading every 10 frames
            set(obj.TextHandle,'String',sprintf('FPS: %2.0f',1/toc));
        end
        
        if obj.CloseRequestFlag
            % Close button was pressed
            delete(obj)
            break
        end
        
        if obj.StopFlag
            % STOP was issued
            obj.isPlaying = false;
            obj.StopFlag = false;
            break
        end
        
    end
    
catch me
    % reset isPlaying and rethrow exception
    obj.isPlaying = false;
    rethrow(me)
end


function buffer(rate)
%BUFFER Uses WHILE instead of PAUSE, to avoid DRAWNOW
while toc<rate, end
