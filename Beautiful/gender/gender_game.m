function [G, TVScreen, Buttonup, Buttondown, Speaker, gameCommands, Hands] = gender_game(options)

    addpath(options.straight_path);

    [screen1, screen2] = getScreens();
%     fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ', screen2));
    fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ', screen2));

%     G = SpriteKit.Game.instance('Title','Gender Game', 'Size', [screen2(3)/1.3, screen2(4)/1.2], 'Location', screen2(1:2), 'ShowFPS', false);
    G = SpriteKit.Game.instance('Title','Gender Game', ...
        'Size', [screen2(3), screen2(4)], 'Location', screen2(1:2), ...
        'ShowFPS', false);

%     SpriteKit.Background('Images/genderbackground3_unscaled.png');
    SpriteKit.Background('Images/Naamloos.png');

    TVScreen = SpriteKit.Sprite('tvscreen');
    TVScreen.initState('off', ones(1,1,3),true); % whole screen green
     TVScreen.initState ('noise', 'Images/TVScreen_noise.png', true);
    for iwoman=1:7
         spritename = sprintf('woman_%d',iwoman);
         pngFile = ['Images/' spritename '.png'];
         TVScreen.initState(spritename , pngFile, true);
    end
    for iman = 1:7
        spritename = sprintf('man_%d', iman);
        pngFile = ['Images/' spritename '.png'];
        TVScreen.initState (spritename, pngFile, true);
    end
%     TVScreen.Location = [screen2(3)/2.58, screen2(4)/2.15]; % KNO
%     groningen
    TVScreen.Location = [screen2(3)/2.42, screen2(4)/2.02]; % Debi's
    TVScreen.State = 'off';
    %  TVScreen.Scale = 1.2
    %  ratioscreentvscreen = 0.81 * screen2(3);
    %  [~, WidthTVScreen] = size(imread ('Images/TVwoman_1.png'));
    %  [HeightBackground, WidthBackground] = size (imread ('Images/genderbackground1_unscaled.png'));
    %  TVScreen.Scale = ratioscreentvscreen/WidthTVScreen;
    
    Speaker = SpriteKit.Sprite ('speaker');
    Speaker.initState ('off', ones(1,1,3), true);
    Speaker.initState ('TVSpeaker_1', ['Images/' 'TVSpeaker_1' '.png'], true);
    Speaker.initState ('TVSpeaker_2', ['Images/' 'TVSpeaker_2' '.png'], true);
    Speaker.Location = [screen2(3)/2.06, screen2(4)/2.47];
    Speaker.Location = [screen2(3)/1.92, screen2(4)/2.34];
    Speaker.State = 'TVSpeaker_1';
    
    Buttonup = SpriteKit.Sprite ('buttonup');
    Buttonup.initState ('on','Images/button_right.png', true);
    Buttonup.initState('press', 'Images/button_right_pressed.png', true)
    Buttonup.initState ('off', ones(1,1,3), true);
    Buttonup.Location = [screen2(3)/1.65, screen2(4)/5.5];
    Buttonup.State = 'off';
    [HeightButtonup, WidthButtonup] = size(imread ('Images/button_right.png'));
    
    addprop(Buttonup, 'clickL');
    addprop(Buttonup, 'clickR');
    addprop(Buttonup, 'clickD');
    addprop(Buttonup, 'clickU');
    Buttonup.clickL = round(Buttonup.Location(1) - round(HeightButtonup/2));
    Buttonup.clickR = round(Buttonup.Location(1) + round(HeightButtonup/2));
    Buttonup.clickD = round(Buttonup.Location(2) - round(WidthButtonup/2));
    Buttonup.clickU = round(Buttonup.Location(2) + round(WidthButtonup/2));
    Buttonup.Depth = 2;
    
    Buttondown = SpriteKit.Sprite ('buttondown');
    Buttondown.initState ('on','Images/button_wrong.png', true);
    Buttondown.initState ('press', 'Images/button_wrong_pressed.png', true);
    Buttondown.initState ('off', ones(1,1,3), true);
    Buttondown.Location = [screen2(3)/1.40, screen2(4)/5.5];
    Buttondown.State = 'off';
    [HeightButtondown, WidthButtondown] = size(imread ('Images/button_wrong.png'));
    
    addprop(Buttondown, 'clickL');
    addprop(Buttondown, 'clickR');
    addprop(Buttondown, 'clickD');
    addprop(Buttondown, 'clickU');
    Buttondown.clickL = round(Buttondown.Location(1) - round(HeightButtondown/2));
    Buttondown.clickR = round(Buttondown.Location(1) + round(HeightButtondown/2));
    Buttondown.clickD = round(Buttondown.Location(2) - round(WidthButtondown/2));
    Buttondown.clickU = round(Buttondown.Location(2) + round(WidthButtondown/2));
    Buttondown.Depth = 2;
    
    gameCommands = SpriteKit.Sprite('controls');
    initState(gameCommands, 'begin','Images/start.png' , true);
    initState(gameCommands, 'finish','Images/finish.png' , true);
    initState(gameCommands, 'empty', ones(1,1,3), true); % to replace the images, 
    % 'none' will give an annoying warning
    gameCommands.State = 'begin';
    gameCommands.Location = [screen2(3)/2.5, screen2(4)/2.5];
    gameCommands.Scale = 1; % make it bigger to cover fishy
    % define clicking areas
    clickArea = size(imread('Images/start.png'));
    addprop(gameCommands, 'clickL');
    addprop(gameCommands, 'clickR');
    addprop(gameCommands, 'clickD');
    addprop(gameCommands, 'clickU');
    gameCommands.clickL = round(gameCommands.Location(1) - round(clickArea(1)/2));
    gameCommands.clickR = round(gameCommands.Location(1) + round(clickArea(1)/2));
    gameCommands.clickD = round(gameCommands.Location(2) - round(clickArea(2)/4));
    gameCommands.clickU = round(gameCommands.Location(2) + round(clickArea(2)/4));
    clear clickArea
    gameCommands.Depth = 10;
    
    %     Hands
    Hands = SpriteKit.Sprite ('hands');
    Hands.initState ('off', ones (1,1,3), true);
%     for ihandbang = 1:2
%         spritename = sprintf('handbang_%d',ihandbang);
%         pngFile = ['Images/' spritename '.png'];
%         Hands.initState(spritename , pngFile, true);
%     end
    addprop(Hands, 'locHands');
    Hands.locHands{1}  = [screen2(3)/1.6, screen2(4)/1.4];
    %   for ihandknob = 1:3
    %       spritename = sprintf('handknob_%d',ihandknob);
    %       pngFile = ['Images/' spritename '.png'];
    %       Hands.initState(spritename , pngFile, true);
    %       Hands.Location = [screen2(3)/1.75, screen2(4)/1.55]; % for handknob
    %   end
    for ihandremote = 1:2
        spritename = sprintf('handremote_%d', ihandremote);
        pngFile = ['Images/' spritename '.png'];
        Hands.initState (spritename, pngFile, true);
    end
    Hands.locHands{2} = [screen2(3)/6.8, screen2(4)/6.8]; % for handremote
    Hands.State = 'off';
    % Hands.Location = [screen2(3)/6.5, screen2(4)/4.5]; % for handremote

end
