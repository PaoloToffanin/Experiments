function addChild(obj,ch)
%ADDCHILD Adds a Sprite to the Game.
%
% See also REMOVECHILD.

% Copyright 2014 The MathWorks, Inc.

if ~isa(ch,'SpriteKit.Sprite')
    error('Only objects of class SpriteKit.Sprite can be added to a Game.')
end
addChild@SpriteKit.internal.ChildManager(obj,ch);