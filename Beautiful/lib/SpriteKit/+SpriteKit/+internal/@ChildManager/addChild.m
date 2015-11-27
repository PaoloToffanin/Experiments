function addChild(obj,ch)
%ADDCHILD Add a child to this CHILDMANAGER.
% No change if this child was already added.
%
% Example:
%  ADDCHILD(MANAGER,CHILD)
%
% See also REMOVECHILD.

% Copyright 2014 The MathWorks, Inc.

alreadyIn = false;
chList = obj.Children;
for k=1:numel(chList)
    if eq(chList{k},ch)
        alreadyIn = true;
        break
    end
end
if ~alreadyIn
    obj.Children{end+1} = ch;
end