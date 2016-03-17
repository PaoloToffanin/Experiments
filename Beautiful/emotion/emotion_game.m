function [G, Clown, Buttonup, Buttondown, gameCommands, Confetti, Parrot, ...
    Pool, Clownladder, Splash, ladder_jump11, clown_jump11, Drops, ExtraClown] = emotion_game

    fig = findobj; %get(groot,'CurrentFigure');
    for item = 1 : length(fig)
        if strcmp(class(fig(item)), 'matlab.ui.Figure') && ...
                ~strcmp(get(fig(item), 'Name'), 'testRunner')
            close(fig(item))
                
        end
                
    end
    clear fig
    
    [~, screen2] = getScreens();
    fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));

    G = SpriteKit.Game.instance('Title','Emotion Game', 'Size', screen2(3:4), 'Location', screen2(1:2), 'ShowFPS', false);

    SpriteKit.Background(resizeBackgroundToScreenSize(screen2, 'Images/circusbackground_unscaled.png'));
    addBorders(G);
%     bkg.Depth = -1;
    
    Clown = SpriteKit.Sprite('clown');
    Clown.initState('angry',['Images/' 'clownemo_1' '.png'], true);
    Clown.initState('sad',['Images/' 'clownemo_2' '.png'], true);
    Clown.initState('joyful',['Images/' 'clownemo_3' '.png'], true);
    Clown.initState('neutral',['Images/' 'clown_neutral' '.png'], true);
    Clown.initState('off', ones(1,1,3), true);
    % SpotLight
    for iClown = 1:5
        spritename = sprintf('clownSpotLight_%d',iClown);
        pngFile = ['Images/' spritename '.png'];
        Clown.initState(spritename, pngFile, true);
    end
%   Clown.Location = [screen2(3)/5.5, screen2(4)/3.2]; 
    [HeightClown, WidthClown, ~] = size(imread ('Images/clownSpotLight_1.png')); 
    Clown.Location = [round(G.Size(1) /25 + WidthClown/2), round(HeightClown/2) + G.Size(2)/35]; 
    Clown.State = 'off';
    Clown.Scale = 1.1;
    Clown.Depth = 1;
    %ratioscreenclown = 0.25 * screen2(4);
    %[HeightClown, ~] = size(imread ('Images/clownfish_1.png'));
    %Clown.Scale = ratioscreenclown/HeightClown;
    clickArea = size(imread('Images/clownSpotLight_1.png'));
    addprop(Clown, 'clickL');
    addprop(Clown, 'clickR');
    addprop(Clown, 'clickD');
    addprop(Clown, 'clickU');
    Clown.clickL = round(Clown.Location(1) - round(clickArea(1)/2));
    Clown.clickR = round(Clown.Location(1) + round(clickArea(1)/2));
    Clown.clickD = round(Clown.Location(2) - round(clickArea(2)/4));
    Clown.clickU = round(Clown.Location(2) + round(clickArea(2)/4));
%       Parrot 
    Parrot = SpriteKit.Sprite ('parrot');
    Parrot.initState('neutral', ['Images/' 'parrot_neutral' '.png'], true);
    Parrot.initState('off', ones(1,1,3), true);
    for iParrot = 1:2
        spritename = sprintf('parrot_%d',iParrot);
        pngFile = ['Images/' spritename '.png'];
        Parrot.initState(spritename, pngFile, true);
    end
    for iparrotshake = 1:3
        spritename = sprintf('parrot_shake_%d', iparrotshake);
        pngFile = ['Images/' spritename '.png'];
        Parrot.initState(spritename, pngFile, true);
    end
    % Parrot.Scale = 0.8;
    Parrot.Location = [screen2(3)/2.2, screen2(4)/1.8];
    Parrot.State = 'off'; 
    Parrot.Depth = 2;
    clickArea = size(imread('Images/parrot_1.png'));
    addprop(Parrot, 'clickL');
    addprop(Parrot, 'clickR');
    addprop(Parrot, 'clickD');
    addprop(Parrot, 'clickU');
    Parrot.clickL = round(Parrot.Location(1) - round(clickArea(1)/2));
    Parrot.clickR = round(Parrot.Location(1) + round(clickArea(1)/2));
    Parrot.clickD = round(Parrot.Location(2) - round(clickArea(2)/4));
    Parrot.clickU = round(Parrot.Location(2) + round(clickArea(2)/4));

%       Buttons 
    Buttonup = SpriteKit.Sprite ('buttonup'); 
    Buttonup.initState ('on','Images/button_right.png', true);
    Buttonup.initState('press', 'Images/button_right_pressed.png', true)
    Buttonup.initState ('off', ones(1,1,3), true); 
    Buttonup.Location = [screen2(3)/2.25, screen2(4)/6];
    Buttonup.State = 'off';
    [HeightButtonup, WidthButtonup] = size(imread ('Images/buttonup_1.png'));
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('Images/buttons_1.png'));
    % Buttonup.Scale = 0.5;
    
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
    Buttondown.Location = [screen2(3)/1.75, screen2(4)/6];
    Buttondown.State = 'off';
    [HeightButtondown, WidthButtondown] = size(imread ('Images/buttondown_1.png'));
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('Images/buttons_1.png'));
    % Buttondown.Scale = 0.5;
    
    addprop(Buttondown, 'clickL');
    addprop(Buttondown, 'clickR');
    addprop(Buttondown, 'clickD');
    addprop(Buttondown, 'clickU');
    Buttondown.clickL = round(Buttondown.Location(1) - round(HeightButtondown/2));
    Buttondown.clickR = round(Buttondown.Location(1) + round(HeightButtondown/2));
    Buttondown.clickD = round(Buttondown.Location(2) - round(WidthButtondown/2));
    Buttondown.clickU = round(Buttondown.Location(2) + round(WidthButtondown/2));
    Buttondown.Depth = 2;

    %      Confetti/Feedback
    Confetti = SpriteKit.Sprite ('confetti');
    Confetti.initState ('off', ones(1,1,3), true);
    for iConfetti = 1:7
        spritename = sprintf('confetti_%d',iConfetti);
        pngFile = ['Images/' spritename '.png'];
        Confetti.initState(spritename, pngFile, true);
    end
    Confetti.Location = [screen2(3)/2.5, screen2(4)-350];
    Confetti.State = 'off';
    Confetti.Scale = 1.4; 
    Confetti.Depth = 5;
    
%      Start and finish     
    gameCommands = SpriteKit.Sprite('controls');
    initState(gameCommands, 'begin','Images/start1.png' , true);
    initState(gameCommands, 'finish','Images/finish1.png' , true);
    initState(gameCommands, 'empty', ones(1,1,3), true); % to replace the images, 'none' will give an annoying warning
    gameCommands.State = 'begin';
    gameCommands.Location = [screen2(3)/2, screen2(4)/2];
    gameCommands.Scale = 1.3; % make it bigger to cover fishy
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

%      Pool 
    Pool = SpriteKit.Sprite ('pool');
    Pool.initState('pool','Images/pool.png', true);
    Pool.initState('empty', ones(1,1,3), true);
    Pool.Location = [screen2(3)/1.11, screen2(4)/3.7];
    Pool.State = 'empty';
    Pool.Depth = 1;
    clickArea = size(imread('Images/pool.png'));
    addprop(Pool, 'clickL');
    addprop(Pool, 'clickR');
    addprop(Pool, 'clickD');
    addprop(Pool, 'clickU');
    Pool.clickL = round(Pool.Location(1) - round(clickArea(1)/2));
    Pool.clickR = round(Pool.Location(1) + round(clickArea(1)/2));
    Pool.clickD = round(Pool.Location(2) - round(clickArea(2)/4));
    Pool.clickU = round(Pool.Location(2) + round(clickArea(2)/4));
    %%      Splash 
    Splash = SpriteKit.Sprite ('splash');
    Splash.initState ('empty', ones(1,1,3), true);
    for isplash = 1:3
        spritename = sprintf('sssplash_%d', isplash);
        pngFile = ['Images/' spritename '.png']; 
        Splash.initState (spritename, pngFile,true);
    end
    Splash.State = 'empty';
    Splash.Location = [screen2(3)/1.2 screen2(4)/2.5];
    Splash.Depth = 6;
    
    %%       Drops 
    Drops = SpriteKit.Sprite ('splashdrops');
    Drops.initState ('empty', ones(1,1,3), true);
    for idrop = 1:2
        spritename = sprintf('sssplashdrops_%d', idrop);
        pngFile = ['Images/' spritename '.png'];
        Drops.initState (spritename, pngFile, true);
    end
    Drops.State = 'empty';
    Drops.Location = [screen2(3)/2.2 screen2(4)/1.9];
    Drops.Depth = 8;
      
    %%  Clownladder 
    Clownladder = SpriteKit.Sprite ('clownladder');
    Clownladder.initState ('empty', ones(1,1,3), true);
    Clownladder.initState ('ground', 'Images/clownladder_0a.png', true)
    Clownladder.State = 'empty';
    Clownladder.Location = [screen2(3)/1.26, screen2(4)/1.40];% screen2(3)/1.26 for sony 1.28 for maclaptop
    Clownladder.Depth = 5;
    let = {'a','b'};
    for iladder = 0:7
        for ilett=1:2
            spritename = sprintf('clownladder_%d%c',iladder,let{ilett});
            pngFile = ['Images/' spritename '.png'];
            Clownladder.initState(spritename, pngFile, true);
        end
    end
    for ijump = 1:11
        spritename = sprintf('clownladder_jump_%d',ijump);
        pngFile = ['Images/' spritename '.png'];
        Clownladder.initState (spritename, pngFile, true);
    end
    
    ExtraClown = SpriteKit.Sprite ('extraclown');
    ExtraClown.initState ('empty', ones(1,1,3), true);
    ExtraClown.initState ('on', 'Images/clown_back.png', true);
    ExtraClown.State = 'empty';
    ExtraClown.Location = [screen2(3)/1.6, screen2(4)/1.7];
    ExtraClown.Scale = 0.8;
    ExtraClown.Depth = 2;
    
    %% last splash
    spritename = sprintf('ladder_jump_11');
    pngFile = ['Images/' spritename '.png'];
    ladder_jump11 = SpriteKit.Sprite ('ladder_jump11');
    ladder_jump11.initState ('empty', ones(1,1,3), true);
    ladder_jump11.initState (spritename, pngFile, true);
    ladder_jump11.Location = [screen2(3)/1.26, screen2(4)/1.40];
    ladder_jump11.Depth = 5;
    spritename = sprintf('clown_jump_11');
    pngFile = ['Images/' spritename '.png'];
    clown_jump11 = SpriteKit.Sprite ('clown_jump11');
    clown_jump11.initState ('empty', ones(1,1,3), true);
    clown_jump11.initState (spritename, pngFile, true);
    clown_jump11.Location = [screen2(3)/1.26, screen2(4)/1.40];
    clown_jump11.Depth = 7;
end
