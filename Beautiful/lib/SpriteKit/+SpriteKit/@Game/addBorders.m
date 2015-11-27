function addBorders(obj)
%ADDBORDERS Add borders to a Game.
% ADDBORDERS(GAME) creates 4 Sprites lining the top, bottom, left, and
% right sides of GAME. This is a convenience function, likely to be used
% with HASCOLLISION.
%
% The border Sprites have associated IDs of 'topborder', 'bottomborder',
% 'leftborder', and 'rightborder'.
%
% See also PHYSICS.HASCOLLISION, SPRITE.

% Copyright 2014 The MathWorks, Inc.

w = obj.Size(1);
h = obj.Size(2);
c = ones(1,w,3);
ct = ones(h,1,3); % faster than PERMUTE

top = SpriteKit.Sprite('topborder');
top.initState('on',c);
set(top,'State','on','Location',[w/2 h+1]);

bottom = SpriteKit.Sprite('bottomborder');
bottom.initState('on',c);
set(bottom,'State','on','Location',[w/2 -1]);

left = SpriteKit.Sprite('leftborder');
left.initState('on',ct);
set(left,'State','on','Location',[-1 h/2]);

right = SpriteKit.Sprite('rightborder');
right.initState('on',ct);
set(right,'State','on','Location',[w+1 h/2]);
