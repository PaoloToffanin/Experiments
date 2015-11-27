function [tf,target] = hasCollision(sprite1,sprite2)
%HASCOLLISION Detects boundary collisions between one or more Sprites.
%
% TF = HASCOLLISION(SPRITE1,SPRITE2) returns true if any boundaries of
% SPRITE1 and SPRITE2 overlap.
%
% [TF,TARGET] = HASCOLLISION(SPRITE) returns true if any boundaries of
% SPRITE and all other Sprites overlap. TARGET will be the first detected
% overlapping Sprite with SPRITE, or empty if there is no collision.
%
% The one-input syntax of the function can become expensive if there are
% many Sprite objects to check, and should be used minimally. Sprites can
% only collide if they share the same Depth.
%
% See also SPRITE.

% Copyright 2014 The MathWorks, Inc.

if ~isa(sprite1,'SpriteKit.Sprite')
    error('Inputs must be SpriteKit.Sprite objects')
end
tf = false;
target = [];

if nargin==1
    % check everything
    G = SpriteKit.Game.instance;
    s = G.Children;
    for k=1:numel(s)
        sprite2 = s{k};
        if sprite2 ~= sprite1
            % use 2-arg function call on each child
            [tf,target] = SpriteKit.Physics.hasCollision(sprite1,sprite2);
            if tf
                % take the first one and leave
                return
            end
        end
    end
else
    % check only collisions between sprite1 and sprite2
    if ~isa(sprite2,'SpriteKit.Sprite')
        error('Inputs must be SpriteKit.Sprite objects')
    end
    
    if sprite1.Depth ~= sprite2.Depth
        % only Sprites with a shared Depth can collide
        return
    end
    
    tf = checkForOverlappingBoundaries(sprite1,sprite2);
    if tf
        target = sprite2;
%         disp(['hit: ' target.ID])
    end
    
end

function tf = checkForOverlappingBoundaries(sprite1,sprite2)

bd1 = sprite1.BData;
bd2 = sprite2.BData;

in = inpolygon(bd2(:,1),bd2(:,2),bd1(:,1),bd1(:,2));

tf = any(in);