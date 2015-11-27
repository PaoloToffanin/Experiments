function scroll(obj,direction,px)
%SCROLL Scroll Background left/right/up/down by a number of pixels.
%
% SCROLL(BKG,DIRECTION,PX) Scrolls the Background BKG by PX number of
% pixels in the specified DIRECTION. The pixel count is relative to the
% original Background image, such that if it is scaled up x10, then 1 pixel
% scroll will actually move the Background by 10 screen pixels relative to
% the Game window.
%
% DIRECTION must be one of 'left','right','up', or 'down'.
%
% Directions are defined such that scrolling 'right' means that the
% *viewing window* of the Background moves 'right', though relatively, the
% Background itself may appear to scroll off to the left.

% Copyright 2014 The MathWorks, Inc.

if ~(isscalar(px) && isnumeric(px) && px>0)
    error('Number of pixels to scroll must be a positive scalar amount')
end

switch direction
    case 'up'
        obj.RefPt = obj.RefPt - [0 px];
    case 'down'
        obj.RefPt = obj.RefPt + [0 px];
    case 'left'
        obj.RefPt = obj.RefPt - [px 0];
    case 'right'
        obj.RefPt = obj.RefPt + [px 0];
    otherwise
        error('MATLAB:SpriteKit:BadScrollDirection',...
            'Unexpected direction "%s". ''Direction'' must be one of: ''left'',''right'',''up'',''down''.',direction);
end

obj.refreshCData;

end