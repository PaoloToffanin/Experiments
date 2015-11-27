function [spriteObject] = getTrajectory(spriteObject, p1, d1, a, targetScale, nStep)

    p0 = spriteObject.Location; % [2, 2];
    d0 = spriteObject.d0; % [20, 0];
%     p1 = [20, 20];
%     d1 = -[-1, -2]*0;

    p1 = p1 - [spriteObject.width, spriteObject.heigth] .* targetScale;
    
%     nStep = 50;
    t = (0:nStep)/nStep;
    nRep = length(t);

    p0 = repmat(p0, nRep, 1);
    p1 = repmat(p1, nRep, 1);
    d0 = repmat(d0, nRep, 1);
    d1 = repmat(d1, nRep, 1);

%     a = 4;
    s = ((1 - cos(2 * pi * t)) * 1/2) .^ a;

    t = cumsum(s)/sum(s);
    t = repmat(t', 1, 2);

    % position of the object
    spriteObject.trajectory = (d1 + d0 - 2*p1 + 2*p0) .* t.^3 + ...
        (3 * p1 - 2 * d0 - d1 - 3 * p0) .* t.^2 + ...
        d0 .* t + ...
        p0;
    % SCALE of the object
    spriteObject.trajectory(:,3) = linspace(spriteObject.Scale, spriteObject.Scale*targetScale, nStep+1);
    spriteObject.iter = 1;
end             