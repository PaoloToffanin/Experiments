function safe = safePosition(pos)
%SAFEPOSITION Figure position that minimizes clipping on screen.
%
% Given a 4-element position vector P, SAFEPOSITION measures the screensize
% and the new figure size to shift the figure left or down to fit on
% screen. This is needed for modal figures, whose titlebar (and the close
% button) may drift out of reach.
%
% Example:
%   SAFEPOSITION([5000 500 400 600]) returns [1515 500 400 600].
%
% Safe values will differ when run on different monitor configurations.

% Copyright 2014 The MathWorks, Inc.


%{
% EG:
% Below is an attempt to improve safePosition for multiple monitors.
% The idea is to guess on what screen we are by looking at which screen
% contains most of the figure.
% The problem is the function is only controlling that the figure isn't
% leaking out of screen on the right side... so I'm demoting it because
% it seems pretty useless anyway.

ss = get(0, 'MonitorPosition');

mp = 0;
mpi = 0;
for i=1:size(ss,1)
    % This is assuming screens are next to each other horizontally
    c1 = pos(1:2);
    c2 = c1+pos(3:4);
    s1 = ss(i,1:2);
    s2 = s1 + ss(i,3:4);
    r1 = [max(s1(1), c1(1)), c1(2)];
    r2 = [min(s2(1), c2(1)), c2(2)];
    p = abs((r2(1)-r1(1))*(r2(2)-r1(2)));
    if p>mp
        p = mp;
        mpi = i;
    end
end

% We are on screen mpi
ss = ss(mpi,:);

if length(pos) ~= 4 || ~isnumeric(pos)
    error('Input must be a 4 element numeric vector.')
end

safe = pos; % retain width and height

pad = [5 55]; % right border, top border + menubar

safe(1) = min(pos(1),ss(3)-pos(3)-pad(1));
safe(2) = min(pos(2),ss(4)-pos(4)-pad(2));

%}

safe = pos;
