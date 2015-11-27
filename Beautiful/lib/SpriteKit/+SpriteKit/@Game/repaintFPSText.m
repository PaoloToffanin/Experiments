function repaintFPSText(obj)
%REPAINTFPSTEXT
% Workaround for when calling IMAGE before TEXT does not render

% Copyright 2014 The MathWorks, Inc.

t = obj.TextHandle;
obj.TextHandle = copyobj(t,obj.AxesHandle);
delete(t)