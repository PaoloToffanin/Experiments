function removeChild(obj,ch)
%REMOVECHILD Removes a Sprite from the Game.
%
% See also ADDCHILD.

% Copyright 2014 The MathWorks, Inc.

if ~isa(ch,'SpriteKit.Sprite')
    error('Only objects of class SpriteKit.Sprite can be removed from a Game.')
end
removeChild@SpriteKit.internal.ChildManager(obj,ch);