function CallbackManager(obj,selectedMenu,~)
%CALLBACKMANAGER Apply mutual-exclusion rules

% Copright 2014 The MathWorks, Inc.

mh = obj.MenuHandles;
newChk = 0;
for k=1:obj.NumMenus
    if mh(k) == selectedMenu
        newChk = k;
        break
    end
end

oldChk = obj.CheckedIndex;
if oldChk ~= newChk
    set(mh(oldChk),'Checked','off')
    set(mh(newChk),'Checked','on')
    obj.CheckedIndex = newChk;
    
    cb = obj.Callback;
    if ~isempty(cb)
        feval(cb,oldChk,newChk);
    end
end
