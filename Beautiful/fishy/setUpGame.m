function [G, bkg, bigFish, bubbles, gameCommands, hourglass] = setUpGame(maxTurns, friendsTypes, targetScale, options)
%function [G, bkg, bigFish, bubbles, screen2, gameCommands, hourglass] = setUpGame(maxTurns)

    % if there are games other windows than the guy already opened close 
    % them
    fig = findobj; %get(groot,'CurrentFigure');
%     if ~isempty(fig)
%         close(fig)
%     end
    for item = 1 : length(fig)
        if strcmp(class(fig(item)), 'matlab.ui.Figure') && ...
                ~strcmp(get(fig(item), 'Name'), 'testRunner')
            close(fig(item))
                
        end
                
    end
    clear fig
    %% introduce the animation bit
        
    [~, screen2] = getScreens();
    fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));
    % Start a new Game on screen 2
    G = SpriteKit.Game.instance('Title','Fishy Game', 'Size', screen2(3:4), 'Location', screen2(1:2), 'ShowFPS', false);
    bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, [options.locationImages 'BACKGROUND_unscaled.png']));
    addBorders(G);
    % Setup the SpriteS
    bigFish = SpriteKit.Sprite('fish_1');
    initState(bigFish,'fish_1', [options.locationImages 'FISHY_TURN_1.png'], true);
    for k=2:10
        spritename = sprintf('FISHY_TURN_%d',k);
        pngFile = [options.locationImages spritename '.png'];
        initState(bigFish, ['fish_' int2str(k)] , pngFile, true);
    end
    bigFish.Location = [screen2(3)/2, screen2(4)-450];
    addprop(bigFish, 'arcAround1'); % arc one contains all same friends
    addprop(bigFish, 'arcAround2'); % arc 2 contains the collection of other friends
    nFriends = 7;
    [x, y] = getArc(0, pi, bigFish.Location(1), bigFish.Location(2), 200, nFriends);
    bigFish.arcAround1 = round([x;y]);
    addprop(bigFish, 'availableLocArc1');
%     bigFish.availableLocArc1 = randperm(nFriends);
    bigFish.availableLocArc1 = nFriends : -1 : 1; % ordinatelly set friends from left to right
    % there must be as many sprites of the circles as many circles we want
    for iCircle = 1 : nFriends
        locFriendsArcOne(iCircle) =  SpriteKit.Sprite('circle');
        locFriendsArcOne(iCircle).initState('circle', 'Images/circle.png', true);
        locFriendsArcOne(iCircle).Location = bigFish.arcAround1(:,iCircle)';
        locFriendsArcOne(iCircle).Scale = targetScale; % this is to make sure that the circle and the friends on the first arc have equal dimensions
    end
    clear iCircle
%% second arc
    nFriends = friendsTypes;
    [x, y] = getArc(0, pi, bigFish.Location(1), bigFish.Location(2), 350, nFriends);
    bigFish.arcAround2 = [x;y];
    addprop(bigFish, 'availableLocArc2');
%     bigFish.availableLocArc2 = randperm(nFriends);
    bigFish.availableLocArc2 = nFriends : -1 : 1; % ordinatelly set friends from left to right
    addprop(bigFish, 'iter');
    bigFish.iter = 1;
    addprop(bigFish, 'countTurns');
    bigFish.countTurns = 0;
    
    bubbles = SpriteKit.Sprite('noBubbles');
    bubbles.initState('noBubbles', [options.locationImages 'bubbles_none' '.png'], true);
    for k=1:4
        spritename = sprintf('bubbles_%d',k);
        pngFile = [options.locationImages spritename '.png'];
        bubbles.initState(spritename, pngFile, true);
        bubbles.Depth = 5;
    end
    
    hourglass = SpriteKit.Sprite ('hourglass');
    hourglass.Location = [screen2(3)/1.10, screen2(4)/1.5];
    ratioscreen = 0.3 * screen2(4);
    [HeightHourglass, WidthHourglass] = size(imread ([options.locationImages 'hourglass_min_0.png']));
    hourglass.Scale = ratioscreen/HeightHourglass;
    counter = 0;
    nHourGlasses = 18;
    nturns = floor(nHourGlasses / maxTurns);
    for k = 0:nturns:17 
        hourglassname = sprintf ('hourglass_%d', counter); 
        pngFile = sprintf([options.locationImages 'hourglass_min_%d.png'], k);
        hourglass.initState (hourglassname, pngFile, true);
        counter = counter + 1;
    end 
    hourglass.State = 'hourglass_0';
    
    addprop(hourglass, 'clickL');
    addprop(hourglass, 'clickR');
    addprop(hourglass, 'clickD');
    addprop(hourglass, 'clickU');
    hourglass.clickL = round(hourglass.Location(1) - round(HeightHourglass/2));
    hourglass.clickR = round(hourglass.Location(1) + round(HeightHourglass/2));
    hourglass.clickD = round(hourglass.Location(2) - round(WidthHourglass/2));
    hourglass.clickU = round(hourglass.Location(2) + round(WidthHourglass/2));

    gameCommands = SpriteKit.Sprite('controls');
%     initState(gameCommands, 'none', zeros(2,2,3), true);
    initState(gameCommands, 'begin',[options.locationImages 'start.png'] , true);
    initState(gameCommands, 'finish',[options.locationImages 'finish.png'] , true);
    initState(gameCommands, 'empty', ones(1,1,3), true); % to replace the images, 'none' will give an annoying warning
    gameCommands.State = 'begin';
    gameCommands.Location = [screen2(3)/2, screen2(4)/2 + 40];
    gameCommands.Scale = 1.5; % make it bigger to cover fishy
    % define clicking areas
    clickArea = size(imread([options.locationImages 'start.png']));
    addprop(gameCommands, 'clickL');
    addprop(gameCommands, 'clickR');
    addprop(gameCommands, 'clickD');
    addprop(gameCommands, 'clickU');
    gameCommands.clickL = round(gameCommands.Location(1) - round(clickArea(1)/2));
    gameCommands.clickR = round(gameCommands.Location(1) + round(clickArea(1)/2));
    gameCommands.clickD = round(gameCommands.Location(2) - round(clickArea(2)/2));
    gameCommands.clickU = round(gameCommands.Location(2) + round(clickArea(2)/2));
    clear clickArea 
    %% ------   start the GAME
%     iter = 0;
%     G.play(@()action(argin));
%     G.play(@action);
%     pause(1);

    
end % end of the setUpGame function 