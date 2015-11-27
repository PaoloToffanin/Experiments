classdef RadioMenuGroup < hgsetget
%RADIOMENUGROUP Wrapper to manage mutually-exclusively checked menus.
    % 
    % See also UIBUTTONGROUP, UIMENU.
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties
        Callback = ''
        CheckedIndex
    end
    
    properties (Access = private)
        MenuHandles
        NumMenus
    end
    
    methods
        
        function obj = RadioMenuGroup(menuArray,varargin)
            %RADIOMENUGROUP Constructor.
            %
            % RMG = RADIOMENUGROUP(H) wraps the uimenu handles H to apply
            % rules of mutally-exclusive radiobuttons.
            %
            % RMG = RADIOMENUGROUP(H,PROPERTY,VALUE,...) will also set
            % property-value pairs on the object. Note these are PV-pairs
            % for the RADIOMENUGROUP object, not the UIMENU handles.
            
            if isempty(menuArray)
                error('The first input must be a non-empty array of uimenu handles')
            end
            N = numel(menuArray);
            for k=1:N
                m = menuArray(k);
                if ~(isprop(m,'Type') && strcmpi(get(m,'Type'),'uimenu'))
                    error('The first input must be a non-empty array of uimenu handles')
                end
            end
            
            checkarray = strcmp(get(menuArray,'Checked'),'on');
            
            if nnz(checkarray)==0
                checkedIdx = 1;
                set(menuArray(1),'Checked','on');
            elseif nnz(checkarray)==1
                checkedIdx = find(checkarray,1);
            else
                toUncheck = checkarray;
                checkedIdx = find(checkarray,1);
                toUncheck(checkedIdx) = 0;
                set(menuArray(toUncheck),'Checked','off');
            end
            
            % assign unified callbacks
            cb = get(menuArray,'Callback');
            if any(~cellfun(@isempty,cb))
                warning('Existing menu callbacks will be overwritten');
            end
            set(menuArray,'Callback',@(o,e)CallbackManager(obj,o))
            
            obj.NumMenus = N;
            obj.MenuHandles = menuArray;
            obj.CheckedIndex = checkedIdx;
            
            if nargin>1
                set(obj,varargin{:});
            end
        end
        
    end
    
    %% SETTERS AND GETTERS
    methods
        
        function set.Callback(obj,val)
            
            if ~isa(val,'function_handle')
                error('''Callback'' must be set to a function handle')
            end
            obj.Callback = val;
            
        end
        
        function set.CheckedIndex(obj,val)
            
            if ~(isnumeric(val) && val > 0 && val <= obj.NumMenus) %#ok<MCSUP>
                error('''CheckedIndex'' must be between 1 and the number of menus, inclusive')
            end
            
            obj.CheckedIndex = val;
            obj.CallbackManager(obj.MenuHandles(val)) %#ok<MCSUP>
            
        end
        
    end
    
    
    %% Private Methods
    methods (Access = private)
        
        CallbackManager(obj,selectedMenu,~)
        
    end
    
end