function varargout = subsref(A,S)
%SUBSREF Subscripted reference for Torus.

% Copyright 2014 The MathWorks, Inc.

if numel(S)>1
    error(MsgCatalog('MATLAB:Torus:RepeatedIndexing'));
end

switch S.type
    
    case '()'
        %%
        if nargout>1
            error(MsgCatalog('MATLAB:MultipleResultsFromIndexing'))
        end
        subs = S.subs;
        N = numel(subs);
        TD = A.TrueData;
        if N==1 % linear indexing
            i = subs{:};
            if iscolon(i)
                varargout{1:nargout} = TD(:);
            elseif isdoubleconvertable(i)
                idx = mod1(i,numel(TD));
                varargout{1:nargout} = TD(idx);
            else
                varargout{1:nargout} = TD(i);
            end
        else
            idx = cell(1,N);
            for k=1:N
                i = subs{k};
                if iscolon(i)
                    idx{k} = 1:size(TD,k);
                elseif isdoubleconvertable(i)
                    idx{k} = mod1(i,size(TD,k));
                else
                    idx{k} = i;
                end
            end
            varargout{1:nargout} = TD(idx{:});
        end
        
    case '{}'
        %%
        subs = S.subs;
        N = numel(subs);
        TD = A.TrueData;
        if ~iscell(TD)
            error(MsgCatalog('MATLAB:cellRefFromNonCell'))
        end
        if N==1 % linear indexing
            i = subs{:};
            if iscolon(i)
                if numel(TD)>1
                    error(MsgCatalog('MATLAB:Torus:CommaSeparated'));
                end
                varargout{1:nargout} = TD{:};
            elseif isdoubleconvertable(i)
                if length(i)>1
                    error(MsgCatalog('MATLAB:Torus:CommaSeparated'));
                end
                idx = mod1(i,numel(TD));
                varargout(1:nargout) = {TD{idx}}; %#ok<CCAT1>
            else
                varargout(1:nargout) = TD{i};
            end
            
        else
            idx = cell(1,N);
            for k=1:N
                i = subs{k};
                if iscolon(i)
                    if size(TD,k)>1
                        error(MsgCatalog('MATLAB:Torus:CommaSeparated'));
                    end
                    idx{k} = 1:size(TD,k);
                elseif isdoubleconvertable(i)
                    if length(i)>1
                        error(MsgCatalog('MATLAB:Torus:CommaSeparated'));
                    end
                    idx{k} = mod1(i,size(TD,k));
                else
                    idx{k} = i;
                end
            end
            varargout{1} = TD{idx{:}};
        end
        
    otherwise
        varargout{1:nargout} = builtin('subsref',A,S);
        
end%switch

if numel(varargout)<nargout
    error(MsgCatalog('MATLAB:maxlhs'))
end

end%fcn

%%
function m = mod1(A,B)
%MOD1 One-based modulus.
m = mod(A-1,B)+1;
end

function tf = iscolon(x)
tf = ischar(x) && strcmp(x,':');
end

function tf = isdoubleconvertable(x)
tf = true;
try
    double(x);
catch
    tf = false;
end
end
