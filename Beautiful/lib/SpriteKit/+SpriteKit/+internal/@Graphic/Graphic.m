classdef (Abstract) Graphic < hgsetget
%GRAPHIC Abstract superclass to encapsulate 2D graphics interactions.
    % This GRAPHIC class shields users from any direct graphic interaction
    % with several key public properties for convenience.
    %
    % GRAPHIC is a subclass of HGSETGET, so that one can modify the
    % properties through SET and GET like typical Handle Graphics.
    %
    % GRAPHIC properties:
    %  Angle    - angle in degrees, measured counter-clockwise
    %  Depth    - used for z-stacking order
    %  Location - two-element position measured in pixels
    %  Scale    - uniform scaling of the GRAPHIC
    %  TformMat - (protected) 4x4 Tranformation Matrix
    %
    % GRAPHIC methods:
    %  GRAPHIC       - constructor
    %  delete        - destructor
    %  updateGfxData - (protected) modify the actual GRAPHIC data
    %
    % See also HGSETGET, HGTRANSFORM, SURFACE.
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (AbortSet)
        
        %ANGLE Rotate the Graphic
        % Rotate by an angle in degrees measured counter-clockwise. Unlike
        % the builtin Handle Graphics utility ROTATE, Angle is always
        % measured from the original position, such that setting Angle to
        % its current value again will not rotate it any more.
        Angle = 0
        
        %DEPTH Change the Depth of the Graphic
        % DEPTH represents the z-stacking order among other Graphic
        % objects. A higher depth brings the Graphic closer to the viewer.
        % The default is 1, but any real number is valid.
        Depth = 1
        
        %LOCATION Change the Location of the Graphic
        % LOCATION is a two-element vector [X,Y] measuring the bottom-left
        % corner of the scene to the center of the Graphic.
        % The default is [0 0].
        Location = [0 0]
        
        %SCALE Scale the Graphic in both x and y directions.
        % Scaling factor applies to the original Graphic, such that setting
        % the scale to its current value again will have no effect.
        % The default is 1, and values must be positive.
        Scale = 1
        
    end
    
    properties (GetAccess = protected, SetAccess = private)
        
        %TFORMMAT 4x4 Transformation Matrix.
        %
        % See also MAKEHGTFORM.
        TformMat = eye(4)
        
    end
    
    properties (Access = private)
        
        %GFXHANDLE Handle to the actual HG object
        GfxHandle
        
        %HGT Handle of the HGTRANSFORM containing the HG object
        HGT
        
    end
    
    %%
    methods
        
        % -----------------------------------------------------------------
        function obj = Graphic()
            %GRAPHIC Constructor
            
            % Make a Game first so it doesn't use a new axes
            SpriteKit.Game.instance();
            
            gfxh = surface(...
                zeros(2),zeros(2),NaN(2),...
                'EdgeColor','none',...
                'DeleteFcn',@(~,~)delete(obj));
            hgt = hgtransform;
            set(gfxh,'Parent',hgt);
            
            obj.GfxHandle = gfxh;
            obj.HGT = hgt;
        end
        
        % -----------------------------------------------------------------
        function delete(obj)
            %DELETE Destructor
            delete(obj.HGT);
        end
        
    end
    
    %% SETTERS AND GETTERS
    methods
        
        % -----------------------------------------------------------------
        function set.Location(obj,val)
            
            if ~(isnumeric(val) && all(size(val)==[1,2]))
                error('Input must be a 1x2 numeric vector')
            end
            
            prevLoc = obj.Location;
            obj.Location = val;
            
            M = makehgtform('translate',[val-prevLoc 0]);
            obj.TformMat = M; %#ok<MCSUP>
            
        end
        
        % -----------------------------------------------------------------
        function set.Angle(obj,val)
            
            if ~(isnumeric(val) && isscalar(val))
                error('Input must be a numeric scalar')
            end
            
            prevAngle = obj.Angle;
            obj.Angle = val;
            
            loc = obj.Location; %#ok<MCSUP>
            
            M = makehgtform(...
                'translate',[loc 0],...
                'zrotate',(val-prevAngle)*pi/180,...
                'translate',[-loc 0]);
            obj.TformMat = M; %#ok<MCSUP>
            
        end
        
        % -----------------------------------------------------------------
        function set.Depth(obj,val)
            
            if ~(isnumeric(val) && isscalar(val))
                error('Input must be a numeric scalar')
            end
            
            prev = obj.Depth;
            obj.Depth = val;
            
            M = makehgtform('translate',[0 0 val-prev]);
            obj.TformMat = M; %#ok<MCSUP>
            
        end
        
        % -----------------------------------------------------------------
        function set.Scale(obj,val)
            
            if ~(isnumeric(val) && isscalar(val) && val>0)
                error('Input must be a positive numeric scalar')
            end
            
            prev = obj.Scale;
            obj.Scale = val;
            
            loc = obj.Location; %#ok<MCSUP>
            
            M = makehgtform(...
                'translate',[loc 0],...
                'scale',val/prev,...
                'translate',[-loc 0]);
            obj.TformMat = M; %#ok<MCSUP>
            
        end
        
        function set.TformMat(obj,val)
            
            M = val*obj.TformMat;
            set(obj.HGT,'Matrix',M); %#ok<MCSUP>
            obj.TformMat = M;
            
        end
        
    end
    
    %% PROTECTED METHODS
    methods (Access = protected)
        
        updateGfxData(obj,X,Y,Z,C)
        
    end
    
end