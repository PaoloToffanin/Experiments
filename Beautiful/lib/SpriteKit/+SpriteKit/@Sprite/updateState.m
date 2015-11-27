function updateState(obj,prevState,newState) %#ok<INUSD>
%UPDATESTATE called after changing state.

% Copyright 2014 The MathWorks, Inc.

cv = obj.CurrentValue;

% pass X/Y/Z/C Data onto Gfx object 
obj.updateGfxData(cv.XData,cv.YData,cv.ZData,cv.CData);
