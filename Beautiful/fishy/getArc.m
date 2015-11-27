function [x, y] = getArc(beginRad, endRad, xCenter, yCenter, radius, nFriends)

% [x, y] = getArc(5*pi/6,pi/6, 9, 4,-1);
% [x, y] = getArc(13*pi/12,23*pi/12, 9, 4, -3);
% [x, y] = getArc(5*pi/3,pi/3, 9, 4,-1);

t = linspace(beginRad, endRad, nFriends);
x = (radius * 1.2) * cos(t) + xCenter;
y = radius * sin(t) + yCenter;
