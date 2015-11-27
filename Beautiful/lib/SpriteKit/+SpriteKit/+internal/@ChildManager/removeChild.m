function removeChild(obj,ch)
%REMOVECHILD Remove a child from this CHILDMANAGER.
% No error if this child does not exist.
%
% Example:
%  REMOVECHILD(MANAGER,CHILD)
%
% See also ADDCHILD.

% Copyright 2014 The MathWorks, Inc.

chList = obj.Children;
N = numel(chList);
for k=1:N
    if eq(chList{k},ch)
        if k==N
            obj.Children = chList(1:k-1);
        else
            obj.Children = chList([1:k-1 k+1:N]);
        end
        break
    end
end