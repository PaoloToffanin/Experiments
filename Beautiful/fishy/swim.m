function [spriteObject] = swim(spriteObject, speedSwim, direction, gameWidth)
% Use linspace to create a line the friends will follow to swim out of the
% Game

% -(sizeFriend + 5): this is to make sure that they really swim out of the
% fishtank

%     trajectory = [linspace(locx, -50, speedSwim); repmat(locy, 1, speedSwim)];

    switch direction
        case 'out'
            trajectory = linspace(spriteObject.Location(1), -(spriteObject.width + 50), speedSwim);
            scale = linspace(1, 0.2, speedSwim);
        case 'in'
            trajectory = linspace(gameWidth + spriteObject.width, spriteObject.Location(1), speedSwim);
            scale = linspace(0.2, 1, speedSwim);
    end
    trajectory = [trajectory; repmat(spriteObject.Location(2), 1, length(trajectory)); scale]';
%     trajectory = [repmat(locy, 1, length(trajectory)); trajectory];
    spriteObject.trajectory = trajectory;
    
    spriteObject.iter = 1;
    
end