classdef (Abstract, HandleCompatible) StateController < handle
%STATECONTROLLER Abstract superclass to manage State.
    % Use STATECONTROLLER when requiring an interface between different
    % keys and values.
    %
    % STATECONTROLLER properties:
    %  CurrentValue - (protected) Value associated with current State
    %  NumStates    - Number of unique states managed by STATECONTROLLER
    %  State        - Unique key associated with a value.
    %
    % STATECONTROLLER methods:
    %  StateController - constructor
    %  cycleNext       - set State forward to the next in the queue
    %  cyclePrevious   - set State backward to the previous in the queue
    %  initState       - initialize a state key to a value
    %  setNoneState    - (protected) set the "none" state to a value
    %  updateState     - (protected) method called after changing state
    %
    % Example, assuming OBJ is an object subclassed from StateController:
    %
    %  initState(OBJ, 'foo', VALUE1)
    %  initState(OBJ, 'bar', VALUE2)
    %  initState(OBJ, 'baz', VALUE3)
    %
    %  OBJ.State % still 'none'
    %  OBJ.State = 'bar';
    %
    %  cycleNext(OBJ)
    %  OBJ.State % now is at 'baz'
    %
    % See also CONTAINERS.MAP.
    
    % Copyright 2014 The MathWorks, Inc.

    properties (AbortSet)
        
        %STATE Key used to associate values.
        % Default is 'none', which can not be overwritten.
        %
        % See also INITSTATE.
        State = 'none'
        
    end
    
    properties (Dependent, SetAccess = private)
        
        %NUMSTATES Number of unique user-defined states on the object.
        %
        % See also STATE.
        NumStates
        
    end
    
    properties (GetAccess = protected, SetAccess = private, Dependent)
        
        %CURRENTVALUE Value associated with current State.
        CurrentValue
        
    end
    
    properties (Dependent, Access = private)
        
        %CURRENTINDEX Queue index of current State.
        CurrentIndex
        
    end
    
    properties (Access = private)
        
        %STATE2VALUE Map object between char Keys and values.
        State2Value
        
        %INDEX2STATE Cell-array mapping ordered indices to State keys.
        Index2State
        
    end
    
    %%
    methods
        
        function obj = StateController()
            %STATECONTROLLER Constructor.
            
            obj.State2Value = containers.Map({'none'},{[]});
            obj.Index2State = SpriteKit.Utils.Torus({});
            
        end
       
    end
    
    %% SETTERS AND GETTERS
    methods
        
        % -----------------------------------------------------------------
        function val = get.NumStates(obj)
            val = obj.State2Value.Count-1; % -1 for the builtin "none" state
        end
        
        % -----------------------------------------------------------------
        function val = get.CurrentIndex(obj)
            val = find(strcmp(obj.Index2State.TrueData,obj.State));
            if isempty(val)
                val = 0;
            end
        end
        
        % -----------------------------------------------------------------
        function val = get.CurrentValue(obj)
            val = obj.State2Value(obj.State);
        end
        
        % -----------------------------------------------------------------
        function set.State(obj,val)
            
            if ~ischar(val)
                error('"State" can only be set to a string')
            end
            
            S2V = obj.State2Value; %#ok<MCSUP>
            if ~isKey(S2V,val)
                error('State "%s" has not been initialized.',val);
            end
            
            prevState = obj.State;
            obj.State = val;
            
            obj.updateState(prevState,val);
            
        end
        
    end
    
    %% Protected Methods
    methods (Access = protected)
        
        updateState(~,~,~)
        
        setNoneState(obj,value)
        
    end
    
end