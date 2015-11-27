classdef Sprite < ...
        SpriteKit.internal.StateController & ...
        SpriteKit.internal.Graphic & ...
        dynamicprops
% SPRITE Sprite object for holding single or multiple graphical layers.
    %
    % SPRITE properties:
    %  Angle        - angle in degrees, measured counter-clockwise
    %  CurrentValue - (protected) Layer associated with current State
    %  Depth        - used for z-stacking order
    %  ID           - identifier
    %  Location     - two-element position measured in pixels
    %  NumStates    - Number of unique States initialized
    %  Scale        - uniform scaling
    %  State        - Current State.
    %
    % SPRITE methods:
    %  addprop         - add a dynamic property to SPRITE
    %  cycleNext       - set State forward to the next in the queue
    %  cyclePrevious   - set State backward to the previous in the queue
    %  initState       - initialize a State key to a Layer
    %  updateGfxData   - (protected) modify the actual graphics data
    %  updateState     - (protected) method called after changing state
    %
    % Example:
    %
    %  S = SpriteKit.Sprite('mySprite');
    %  S.initState('summer','demo/seasons/summer.png')
    %  S.initState('random',randi(255,20,20,3))
    %
    %  S.State = 'summer'; % use dot assignment
    %  set(S,'Location',[200 250],'Scale',2.4,'Angle',30) % or SET
    %
    % See also GAME, BACKGROUND.
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (SetAccess = private)
        
        %ID Identifier of SPRITE. Should be unique in the Game.
        ID
        
    end
    
    properties (Access = private)
        
        %OWNINGGAME Owning Game associated with SPRITE
        OwningGame
        
    end
    
    properties (SetAccess = private, Hidden, Dependent)
        
        %BDATA Dynamic boundary data of current Sprite
        BData
        
    end
    
    
    %%
    methods
        
        % -----------------------------------------------------------------
        function obj = Sprite(id)
            %SPRITE Constructor
            
            if ~ischar(id)
                error('Sprite ID must be a string');
            end
            obj.ID = id;
            
            G = SpriteKit.Game.instance;
            obj.Location = G.Size/2;
            G.addChild(obj);
            obj.OwningGame = G;
            
            noneState = SpriteKit.internal.Layer(zeros(2,2,3),false);
            noneState.ZData = NaN(2);
            obj.setNoneState(noneState);
            
        end
        
        % -----------------------------------------------------------------
        function delete(obj)
            %DELETE Destructor
            obj.OwningGame.removeChild(obj);
        end
        
    end
    
    %% SETTERS AND GETTERS
    methods
        
        function val = get.BData(obj)
            % Since the Layer's BData is static, getting updated BData on a
            % moving Sprite requires some calculations on the
            % Transformation Matrix.
            
            bd = obj.CurrentValue.BData;
            x = bd(:,1);
            y = bd(:,2);
            M = obj.TformMat;
            val = [...
                y*M(2,1) + x*M(2,2) + M(2,4),...
                y*M(1,1) + x*M(1,2) + M(1,4)];
            
        end
        
    end
    
    %%
    methods (Access = protected)
        
        updateState(obj,prevState,newState)
        
    end
    
end