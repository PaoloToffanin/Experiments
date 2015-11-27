classdef Game < hgsetget & SpriteKit.internal.ChildManager
%GAME Console to host Game and Sprite interaction.
    % GAME provides a pre-configured figure window into which Sprites and
    % Backgrounds populate. A menubar is available with "Window" options:
    % Normal, Small, or Large. Changing this scaling will stretch all of
    % the contents and will not disrupt any previous calculations.
    %
    % Only one instance of GAME is permitted at any one time. Due to this
    % Singleton behavior, GAME's contructor is marked private, and creation
    % must be redirected through the static "instance" method.
    %
    % Example:
    %  G = SpriteKit.Game.instance;
    %  % or
    %  G = SpriteKit.Game.instance(PROPERTY,VALUE,...)
    %
    % Note that the 'Size' and 'Location' properties can only be set during
    % GAME construction so that any future calculations can work from a
    % static reference and simplify the game logic. The 'Size' value will
    % be associated with the "Normal" window scaling.
    %
    % GAME properties:
    %  Size     - Size of figure window in pixels
    %  Location - Location of figure window in pixels
    %  Title    - Title of figure window
    %  ShowFPS  - optionally show/hide real-time Frames-per-Second
    %
    % GAME callbacks:
    %  onKeyPress     - function to execute on key press
    %  onKeyRelease   - function to execute on key release
    %  onMousePress   - function to execute on mouse press
    %  onMouseRelease - function to execute on mouse release
    %
    % GAME methods:
    %  addBorders  - add border Sprites to top/bottom/left/right edges
    %  addChild    - add a Sprite to GAME
    %  instance    - (static) create a new GAME or retrieve existing one
    %  play        - begin gameplay
    %  removeChild - remove a Sprite to GAME
    %  stop        - stop gameplay
    % 
    % See also SPRITE.
    
    % Copyright 2014 The MathWorks, Inc.
    
    
    properties (Dependent, SetAccess = private)
        
        %SIZE Size of figure window in pixels.
        % This can only be set on construction.
        %
        % See also INSTANCE, LOCATION.
        Size
        
        %LOCATION Location of figure window
        % Measured to the bottom-left corner. This can only be set on
        % construction.
        %
        % See also INSTANCE, SIZE.
        Location
        
    end
    
    properties (Dependent)
        
        %TITLE Title of figure window
        Title
        
        %ONKEYPRESS Function to execute on key press.
        % This redirects to figure's WindowKeyPressFcn.
        %
        % See also ONKEYRELEASE.
        onKeyPress
        
        %ONKEYRELEASE Function to execute on key release
        % This redirects to figure's WindowKeyReleaseFcn.
        %
        % See also ONKEYPRESS.
        onKeyRelease
        
        %ONMOUSEPRESS Function to execute on mouse press
        % This redirects to figure's WindowButtonDownFcn.
        %
        % See also ONMOUSERELEASE.
        onMousePress

        % paol8 adds functionality to resize background to fit monitor size
        %FITSCREEN should game fill monitor resolution 
%         fitScreen
        
        %ONMOUSERELEASE Function to execute on mouse release
        % This redirects to figure's WindowButtonUpFcn.
        %
        % See also ONMOUSEPRESS.
        onMouseRelease
        
        %DATA STORAGE of the current trial
        % time
        % keyPushed
        % correctKey
        
        
    end
    
    properties (AbortSet)
        
        %SHOWFPS True/false value whether to display real-time
        %Frames-per-second or not. Suggested to use during development, but
        %then set false upon release. Default is true.
        ShowFPS = true
        
    end
    
    properties %(Access = private) % EG: made public
        
        %FIGUREHANDLE Handle to figure
        FigureHandle
        
        %AXESHANDLE Handle to axes
        AxesHandle
        
        %TEXTHANDLE Handle to text
        TextHandle
        
        %CLOSEREQUESTFLAG Boolean flag to close safely
        CloseRequestFlag = false
        
        %STOPFLAG Boolean flag to stop safely
        StopFlag = false
        
        %ISPLAYING Boolean flag indicating if GAME is playing or not
        isPlaying = false
        
    end
    
    %%
    methods (Access = private)
        
        function obj = Game(varargin)
            %GAME Private constructor.
            %
            % See also INSTANCE.
            
            % Figure
            fh = figure(...
                'Toolbar',     'none',...
                'Menubar',     'none',...
                'NumberTitle', 'off',...
                'DockControls','off',...
                'Resize',      'on',... % paolo changed to on so that game size can be adapted to monitor resolution
                'Visible',     'off',...
                'Renderer',    'zbuffer',...
                'CreateFcn',   'movegui center',...
                'DeleteFcn',    @(o,e)delete(obj));
            
            % Window scaling menu
            
%             hmenu = uimenu('Parent',fh,...
%                 'Label','Window');
%             m(1) = uimenu(hmenu,'Label','Small');
%             m(2) = uimenu(hmenu,'Label','Normal','Checked','on');
%             m(3) = uimenu(hmenu,'Label','Large');
%             SpriteKit.internal.RadioMenuGroup(m,...
%                 'Callback',@(idx1,idx2)MenuCallbackManager(obj,idx1,idx2));
            
            % Axes
            pos = get(fh,'Position');
            ah = axes(...
                'Parent',  fh,...
                'Units',   'normalized',...
                'Position',[0 0 1 1],...
                'XLimMode','manual',...
                'YLimMode','manual',...
                'XLim',    [0 pos(3)],...
                'YLim',    [0 pos(4)],...
                'Visible', 'off');
            
            obj.FigureHandle = fh;
            obj.AxesHandle = ah;
            obj.TextHandle = text(10,pos(4)-15,'FPS: ','Parent',ah);
            
            if nargin>0
                set(obj,varargin{:});
            end
            
            set(fh,'Visible','on');
            
        end
        
    end
    
    %%
    methods
        
        function delete(obj)
            %DELETE Destructor
            try
                ch = obj.Children;
                for k=1:numel(ch)
                    delete(ch{k});
                end
                delete(obj.AxesHandle);
                delete(obj.FigureHandle);
            catch
            end
        end
        
    end
    
    %% SETTERS AND GETTERS
    methods
        
        % -----------------------------------------------------------------
        function set.onKeyPress(obj,val)
            set(obj.FigureHandle,'WindowKeyPressFcn',val)
        end
        
        % -----------------------------------------------------------------
        function val = get.onKeyPress(obj)
            val = get(obj.FigureHandle,'WindowKeyPressFcn');
        end
        
        % -----------------------------------------------------------------
        function set.onKeyRelease(obj,val)
            set(obj.FigureHandle,'WindowKeyReleaseFcn',val)
        end
        
        % -----------------------------------------------------------------
        function val = get.onKeyRelease(obj)
            val = get(obj.FigureHandle,'WindowKeyReleaseFcn');
        end
        
        % -----------------------------------------------------------------
        function set.onMousePress(obj,val)
            set(obj.FigureHandle,'WindowButtonDownFcn',val)
        end
        
        % -----------------------------------------------------------------
        function val = get.onMousePress(obj)
            val = get(obj.FigureHandle,'WindowButtonDownFcn');
        end
        
        % -----------------------------------------------------------------
        function set.onMouseRelease(obj,val)
            set(obj.FigureHandle,'WindowButtonUpFcn',val);
        end
        
        % -----------------------------------------------------------------
        function val = get.onMouseRelease(obj)
            val = get(obj.FigureHandle,'WindowButtonUpFcn');
        end
        
        % -----------------------------------------------------------------
        function set.Title(obj,val)
            set(obj.FigureHandle,'Name',val);
        end
        
        % -----------------------------------------------------------------
        function val = get.Title(obj)
            val = get(obj.FigureHandle,'Name');
        end
        
%         % -----------------------------------------------------------------
%         function set.fitScreen(obj,val)
%             set(obj.FigureHandle,'fitScreen',val);
%         end
%         
%         % -----------------------------------------------------------------
%         function val = get.fitScreen(obj)
%             val = get(obj.FigureHandle,'fitScreen');
%         end
        
        
        
        % -----------------------------------------------------------------
%         function set.time(obj,val)        
%             set(obj.FigureHandle,'Time',val);
%         end
%         % -----------------------------------------------------------------
%         function val = get.time(obj)
%             val = get(obj.FigureHandle,'Time');
%         end
%         
%         % -----------------------------------------------------------------
%         function set.keyPushed(obj,val)  
%             set(obj.FigureHandle,'Key',val);
%         end
%         % -----------------------------------------------------------------
%         function val = get.keyPushed(obj)
%             val = get(obj.FigureHandle,'Key');
%         end
%         
%         % -----------------------------------------------------------------
%         function set.correctKey(obj,val)  
%             set(obj.FigureHandle,'cKey',val);
%         end
%         % -----------------------------------------------------------------
%         function val = get.correctKey(obj)
%             val = get(obj.FigureHandle,'cKey');
%         end
%         
        % -----------------------------------------------------------------
        function set.Location(obj,val)
            p = get(obj.FigureHandle,'Position');
            p = obj.safePosition([val p(3:4)]);
            set(obj.FigureHandle,'Position',p);
        end
        
        % -----------------------------------------------------------------
        function val = get.Location(obj)
            p = get(obj.FigureHandle,'Position');
            val = p(1:2);
        end
        
        % -----------------------------------------------------------------
        function set.Size(obj,val)
            p = get(obj.FigureHandle,'Position');
            p = obj.safePosition([p(1:2) val]);
            set(obj.FigureHandle,'Position',p);
            set(obj.AxesHandle,...
                'XLim',[0 p(3)],...
                'YLim',[0 p(4)]);
            set(obj.TextHandle,'Position', [10 val(2)-15]);
        end
        
        % -----------------------------------------------------------------
        function val = get.Size(obj)
            % Use axes limits instead of Figure size since these won't
            % change when the Window Size is stretched
            lim = get(obj.AxesHandle,{'XLim','YLim'});
            val = [lim{1}(2) lim{2}(2)];
        end
        
        % -----------------------------------------------------------------
        function set.ShowFPS(obj,val)
            if val
                set(obj.TextHandle,'Visible','on') %#ok<MCSUP>
            else
                set(obj.TextHandle,'Visible','off') %#ok<MCSUP>
            end
            obj.ShowFPS = val;
        end
        
        % -----------------------------------------------------------------
        function set.isPlaying(obj,val)
            
            fh = obj.FigureHandle; %#ok<MCSUP>
            m = findall(fh,'Tag','StopMenuOption');
            if val
                set(fh,'CloseRequestFcn',@(o,e)prep2close(obj))
                set(m,'Enable','on');
            else
                set(fh,'CloseRequestFcn','closereq')
                set(m,'Enable','off');
            end
            function prep2close(obj)
                % Pass a flag back to the PLAY function
                obj.CloseRequestFlag = true;
            end
            obj.isPlaying = val;
        end
        
    end
    
    %%
    methods (Static)
        
        obj = instance(varargin)
        
        safe = safePosition(pos)
        
    end
    
    %%
    methods (Access = private)
        
        MenuCallbackManager(obj,idxOld,idxNew)
        
    end
    
    %%
    methods (Hidden)
        
        repaintFPSText(obj)
        
    end
    
end
