function obj = instance(varargin)
%INSTANCE Singleton Game instance
% This static method is the only way to call the private Game constructor,
% to retain Singleton behavior (one Game exists at a time). Games are
% destroyed after either closing the figure or calling DELETE on the Game
% object. Only after that will a new instance be created.
%
% G = SpriteKit.Game.instance() % creates default Game
%
% G = SpriteKit.Game.instance(PROPERTY,VALUE,...) % initializes properties
%
% Examples:
%  % this creates a new Game with Size [200 200]:
%  G1 = SpriteKit.Game.instance('Size',[200 200]);
%  % this gives back the same handle, with no change in size:
%  G2 = SpriteKit.Game.instance('Size',[300 300]);
%
% See also GAME.

% Copyright 2014 The MathWorks, Inc.

persistent inst

if isempty(inst) || ~isvalid(inst)
    obj = SpriteKit.Game(varargin{:});
    inst = obj; % cache it
else
    obj = inst;
end