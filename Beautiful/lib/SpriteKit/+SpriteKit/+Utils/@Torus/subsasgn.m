function B = subsasgn(A,S,val)
%SUBSASGN Subscripted assignment for Torus.

% Copyright 2014 The MathWorks, Inc.

switch S.type
    case '.'
        if strcmp(S.subs,'TrueData')
            error(MsgCatalog('MATLAB:class:SetProhibited'))
        else
            B = builtin('subsasgn',A,S,val);
        end
        
    case '()'
        if size(A.TrueData,1) > 1 && size(A.TrueData,2) > 1 ...
                && numel(S.subs) == 1  ...
                && isscalar(S.subs{1}) ...
                && isscalar(val) ...
                && S.subs{1} > numel(A.TrueData)
            error(MsgCatalog('MATLAB:indexed_matrix_cannot_be_resized'))
        else
            A.TrueData = builtin('subsasgn',A.TrueData,S,val);
            B = A;
        end
        
    otherwise
        A.TrueData = builtin('subsasgn',A.TrueData,S,val);
        B = A;
end
