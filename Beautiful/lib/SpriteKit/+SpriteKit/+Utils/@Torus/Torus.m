classdef (Sealed) Torus
%TORUS Modular data wrapper.
    % Creating a Torus about given data provides the ability to safely
    % access what would be "Out of Bounds" indices by using one-based
    % modulus to wrap the data end-over-end.
    %
    % TORUS properties:
    %  TrueData - (read-only) raw data wrapped by TORUS.
    %
    % Examples:
    %  T = Torus(1:10)
    %  T(-3:1) % == [7 8 9 10 1]
    %  T(end:end+2) % == [10 1 2]
    %  T(3:4,5:7) % == [5 6 7; 5 6 7]
    %
    % See also MOD, REPMAT.
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (SetAccess = private)
        %TRUEDATA (read-only) raw data wrapped by TORUS. This can
        %implicitly be "set" through subscript assignment.
        % For example,
        %  T = Torus(1:10);
        %  T.TrueData % == 1:10
        %  T(15) = 2 % this would extend TRUEDATA to a length of 15.
        %  T.TrueData % == [1:10 0 0 0 0 2]
        TrueData
    end
    
    methods
        
        function obj = Torus(data)
            %TORUS Create a new Torus.
            % Examples:
            %  T = Torus(1:10);
            %  T = Torus(magic(5));
            %  T = Torus({'foo','bar','baz'});
            obj.TrueData = data;
        end
        
    end
    
    methods (Hidden)
        
        function out = end(obj,k,n)
             out = builtin('end',obj.TrueData,k,n);
        end
        
        B = subsasgn(A,S,val)
        
        varargout = subsref(A,S)
        
    end
    
end
