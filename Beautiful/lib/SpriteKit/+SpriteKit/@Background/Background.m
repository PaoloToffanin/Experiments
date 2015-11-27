classdef Background < handle
%BACKGROUND Background graphic.
    % 
    % SpriteKit.Background(...) applies the CData or image to the
    % background of the Game. The image will be anchored to the bottom-left
    % of the window, and tile to fill the entire window.
    %
    % BACKGROUND properties:
    %  Scale - uniform scaling for BACKGROUND.
    %
    % BACKGROUND methods:
    %  Background - constructor
    %  delete - destructor
    %  scroll - scroll BACKGROUND left/right/up/down
    %
    % See also GAME, SPRITE.
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (AbortSet)
        
        %SCALE Scale the Background in both x and y directions with the
        % bottom-left corner anchored in the window. Scaling factor applies
        % to the original Background, such that setting the scale to its
        % current value again will have no effect. The default is 1, and
        % values must be positive.
        Scale = 1.0
        
    end
    
    properties (Access = private)
        
        %TILECDATA Torus object wrapping the true CData used to tile the
        %window.
        TileCData
        
        %REFPT Reference point, measured from the bottom-left corner of the
        %TileCData.
        RefPt = [0 0]
        
        %WINDOWSIZE Size of Game, cached for performance.
        WindowSize
        
        %GFXHANDLE HG Handle to graphics object.
        GfxHandle
        
    end
    
    
    %%
    methods
        
        % -----------------------------------------------------------------
        function obj = Background(in)
            %BACKGROUND Constructor
            % BKG = BACKGROUND(IMG) for image file IMG
            % BKG = BACKGROUND(C) for TrueColor CData, a NxMx3 matrix whose
            % values are between 0 and 1.
            
            G = SpriteKit.Game.instance;
            ws = G.Size;
            obj.WindowSize = ws;
            
            c = getTrueColorCData(in);
            
            % align the bottom-left corner instead of the top-left corner.
            c = flip(c);
            
            % Assign to a Torus. This way we avoid creating a huge image
            % where only a small part is actually visible. Use the Torus
            % datatype to tile naturally.
            T = SpriteKit.Utils.Torus(c);
            obj.TileCData = T;
            
            obj.GfxHandle = image(...
                'XData',[1 ws(1)],...
                'YData',[1 ws(2)],...
                'CData',T(1:ws(2),1:ws(1),:),...
                'DeleteFcn',@(~,~)delete(obj));
            
            % workaround for TEXT getting covered by IMAGE
            G.repaintFPSText();
        end
        
        % -----------------------------------------------------------------
        function delete(obj)
            %DELETE Destructor
            delete(obj.GfxHandle)
        end
        
    end
    
    %% SETTERS AND GETTERS
    methods
        
        % -----------------------------------------------------------------
        function set.Scale(obj,val)
            
            if ~(isscalar(val) && isnumeric(val) && val>0)
                error('Input must be a positive numeric scalar')
            end
            
            obj.Scale = val;
            
            obj.refreshCData;
            
        end
        
    end
    
    %% PRIVATE METHODS
    methods (Access = private)
        
        refreshCData(obj)
        
    end
    
end

%%
function data = getTrueColorCData(in)
%GETTRUECOLORCDATA Guaranteed to return a NxMx3 TrueColor matrix.

if ischar(in)
    % handle png
    if strfind(in, 'png')
      [data, map, alpha] = imread(in, 'PNG');
    else
      [data,map] = imread(in);
    end
      
    if ~isempty(map) % want true-color
        data = ind2rgb(data,map);
    end
else
    % raw data
    if ~(isnumeric(in) && ndims(in)==3 && size(in,3)==3)
        error('MATLAB:SpriteKit:BadCData',...
            'Raw data must be a numeric NxMx3 matrix, or provide an existing filename.');
    end
    data = in;
end

end