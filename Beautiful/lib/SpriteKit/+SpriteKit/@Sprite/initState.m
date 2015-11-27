function initState(obj,stateKey,layer,trans)
%INITSTATE Initialize State with unique Key to associated SpriteKit.Layer.
% When initializing states, order is preserved in the queue, to be used
% with the CYCLENEXT/CYCLEPREVIOUS methods.
%
% INITSTATE(SPRITE,StateName,IMGFILE) uses an image file as this state.
% INITSTATE(SPRITE,StateName,CDATA) uses raw true color CData for this
% state. CData must be an NxMx3 matrix whose values are between 0 and 1.
% INITSTATE(...,TRANS) where TRANS is true or false for transparency or
% opacity, respectively.
%
% Example:
%  S = SpriteKit.Sprite('foo');
%  INITSTATE(S,'randomswatch',rand(25,25,3))
%  INITSTATE(S,'fromFile','foo/bar.png',true)
%
% See also CYCLENEXT, CYCLEPREVIOUS, LAYER, STATE.

% Copyright 2014 The MathWorks, Inc.

narginchk(3,4)

if nargin==3
    trans = false;
end
L = SpriteKit.internal.Layer(layer,trans);

% forward to base class
initState@SpriteKit.internal.StateController(obj,stateKey,L);