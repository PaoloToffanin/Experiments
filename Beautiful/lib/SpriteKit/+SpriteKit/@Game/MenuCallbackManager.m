function MenuCallbackManager(obj,idxOld,idxNew)
%MENUCALLBACKBACKMANAGER Single-source dispatcher for menu callbacks.
% Scales Game window based on selection.

% Copyright 2014 The MathWorks, Inc.

p = get(obj.FigureHandle,'Position');
centerpt = p(1:2)+p(3:4)/2;

% scale factors
mult = 1.75;
scaleMat = [
    1     , 1/mult, 1/mult/2;
    mult  , 1     , 1/mult  ;
    mult*2, mult  , 1       ];
scaleFactor = scaleMat(idxNew,idxOld);

% scale it about the centerpoint
p(3:4) = p(3:4)*scaleFactor;
p(1:2) = centerpt-p(3:4)/2;

% update figure position
p = obj.safePosition(p);
set(obj.FigureHandle,'Position',p);

% update text font
font = get(obj.TextHandle,'FontSize');
set(obj.TextHandle,'FontSize',font*scaleFactor);
