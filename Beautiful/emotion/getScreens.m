function [screen1, screen2] = getScreens()
% Return SCREEN1 and SCREEN2 as [LEFT, BOTTOM, WIDTH, HEIGHT]
% SCREEN1 is supposed to be the experimenter's screen and SCREEN2 the
% participants' screen.



s = get(0, 'MonitorPositions');

screen1 = s(1,:);

% PT: MAC have the primary screen as secondary screen, it seems
if size(s,1)==1
    screen2 = screen1;
else
    screen2 = s(2,:);
    if s(2,1) == 1
        screen1 = s(2, :);
        screen2 = s(1, :);
    end
end

