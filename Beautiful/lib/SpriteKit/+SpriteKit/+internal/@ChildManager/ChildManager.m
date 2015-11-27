classdef (Abstract) ChildManager < handle
%CHILDMANAGER Abstract superclass to handle child management.
    %
    % CHILDMANAGER properties:
    %  Children - Read-only cell array of children in CHILDMANAGER.
    %
    % CHILDMANAGER methods:
    %  addChild    - adds a child to CHILDMANAGER
    %  removeChild - removes a child from CHILDMANAGER
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (SetAccess = private)
        Children
    end
    
end