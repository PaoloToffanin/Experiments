function friends = friendUpdate(gameWidth, scrsz4, friend, options)
    

    friends = {};
    endingPos = [[-70 70];[5 70];[70 70]];

    for iFriend = 1 : 3
        el = SpriteKit.Sprite(sprintf('friend%d', iFriend));
        
        el.initState('talk1', [options.locationImages friend '_talk_a.png'], true);
        el.initState('talk2', [options.locationImages friend '_talk_b.png'], true);
        el.initState('talk3', [options.locationImages friend '_talk_a.png'], true);
        el.initState('talk4', [options.locationImages friend '_talk_c.png'], true);
        el.initState('swim1', [options.locationImages friend '_swim_a.png'], true);
        el.initState('swim2', [options.locationImages friend '_swim_b.png'], true);
        el.initState('swim3', [options.locationImages friend '_swim_a.png'], true);
        el.initState('swim4', [options.locationImages friend '_swim_c.png'], true);
        el.initState('choice', [options.locationImages friend '_choice.png'], true);
        el.initState('error', [options.locationImages friend '_error.png'], true);
        
        % define clicking areas
        clickArea = size(imread([options.locationImages friend '_talk_a.png']));
        addprop(el, 'width');
        el.width = round(clickArea(2)/2);
        addprop(el, 'heigth');
        el.heigth = round(clickArea(1)/2);
        el.Location = [round(gameWidth * (iFriend+1)/5) - el.width,  el.heigth + (scrsz4 - 750)];
        addprop(el, 'clickL');
        addprop(el, 'clickR');
        addprop(el, 'clickD');
        addprop(el, 'clickU');
        el.clickL = round(el.Location(1) - el.width);
        el.clickR = round(el.Location(1) + el.width);
        el.clickD = round(el.Location(2) - el.heigth);
        el.clickU = round(el.Location(2) + el.heigth);
        % set up locations for bubbles
        addprop(el, 'bubblesX');
        el.bubblesX = round(el.Location(1) - el.width);
        addprop(el, 'bubblesY');
        el.bubblesY = round(el.Location(2) + el.heigth);

        
        el.State = 'talk1';
        cycleNext(el) % update object state (I think this is necessary to get animation started)
        
        addprop(el, 'd0');
        addprop(el, 'trajectory');
        addprop(el, 'iter');
        el.iter = 1;
        addprop(el, 'key');
        el.key = iFriend;
        addprop(el, 'filename');
        el.filename = friend;
%         friends{end+1} = el;
        friends{iFriend} = el;
        friends{iFriend}.d0 = endingPos(iFriend, :);
        
    end
%     % we need to find a way to insert this in the loop as well... 
%     friends{1}.d0 = [-70 70];
%     friends{2}.d0 = [5 70];
%     friends{3}.d0 = [70 70];


end