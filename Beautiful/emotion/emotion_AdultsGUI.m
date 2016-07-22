function emotion_AdultsGUI(varargin)
% interface for emotion task
% 
% emotion_AdultsGUI('test')
% emotion_AdultsGUI('training')
% emotion_AdultsGUI() will run in autoplay, testing phase

%% process function's input
    simulateSubj = true;
    phase = 'training';
    if nargin > 0
        phase = varargin{1};
        simulateSubj = false;
%         if strcmp(phase, 'autoplay')
%             simulateSubj = true;
%         end
    end

%%    
    options.paths2Add = {
        '../lib/MatlabCommonTools/'
%         '../lib/vocoder_2015', ...
%         '../lib/STRAIGHTV40_006b', ...
        };
    for ipath = 1 : length(options.paths2Add)
        if ~exist(options.paths2Add{ipath}, 'dir')
            error([options.paths2Add{ipath} ' does not exists, check the ../']);
        else
            addpath(options.paths2Add{ipath});
        end
    end
    
%% Create GUI 
    screen = monitorSize;
    screen.xCenter = round(screen.width / 2);
    screen.yCenter = round(screen.heigth / 2);
    disp.width = 600;
    disp.heigth = 400;
    disp.Left = screen.left + screen.xCenter - (disp.width / 2);
    %    disp.Down = screen.xCenter + disp.halfWidth;
    disp.Up = screen.bottom + screen.yCenter - (disp.heigth / 2);
    %    disp.Right = screen.yCenter + disp.halfHeigth;

    f = figure('Visible','off','Position',[disp.Left, disp.Up, disp.width, disp.heigth], ...
        'Toolbar', 'none', 'Menubar', 'none', 'NumberTitle', 'off');

    %  Construct the components.
    bottonHeight= 50;
    bottonWidth = 100;
    bottonYpos = round(disp.heigth /2) - round(bottonHeight / 2);
    buttonName = {'Sad', 'Joyful', 'Angry'};
    buttonName = buttonName(randperm(3));
    buttonName{4} = 'START';
    %    bottonXpos = disp.width;
    leftBox = uicontrol('Style','pushbutton','String', buttonName{1},...
        'Position',[disp.width * 1/4 - round(bottonWidth / 2), bottonYpos, bottonWidth, bottonHeight],...
        'Callback',@left_Callback, 'Visible', 'Off');
    centerBox = uicontrol('Style','pushbutton','String', buttonName{4},...
        'Position',[disp.width * 2/4 - round(bottonWidth / 2), bottonYpos,bottonWidth,bottonHeight],...
        'Callback',@center_Callback);
    rightBox = uicontrol('Style','pushbutton','String', buttonName{3},...
        'Position',[disp.width * 3/4 - round(bottonWidth / 2), bottonYpos, bottonWidth, bottonHeight],...
        'Callback',@right_Callback, 'Visible', 'Off');

    % Initialize the GUI.
    % Change units to normalized so components resize
    % automatically.
    f.Units = 'normalized';
    leftBox.Units = 'normalized';
    centerBox.Units = 'normalized';
    rightBox.Units = 'normalized';

    % Assign the GUI a name to appear in the window title.
    f.Name = 'Emotion task';
    % Move the GUI to the center of the screen.
    movegui(f,'center')
    
    % load stimuli for presentation
    cue = {'normalized', 'intact'};
    cue = cue(randperm(length(cue)));
    cue = cue{1};
    switch cue
        case 'intact'
            soundDir = [getHome '/sounds/Emotion/'];
        case 'normalized'
            soundDir = [getHome '/sounds/Emotion_normalized/'];
        otherwise
            fprintf('clue %s is unknown\n', cue);
            return
    end
%     emotionvoices = classifyFiles(soundDir);
%     emotionvoices = files2play(emotionvoices, phase);
    emotionvoices = files2play(classifyFiles(soundDir, phase), phase);
    options = [];
%     [expe, options] = building_conditions2(options);
    [expe, options] = building_conditions(options);
    
    % initialize response structure
    resp = repmat(struct('key', 0, 'acc', 0), 1);
    % initialize response counter
    iresp = 0;

%     expe.(phase).condition(iTrial).voicelabel
%     emotionvoices(indexes(toPlay)).emotion
    % Make the GUI visible.
    f.Visible = 'on';
    
    if simulateSubj
        autoplay;
    end

    %  Callbacks for simple_gui. These callbacks automatically
    %  have access to component handles and initialized data
    %  because they are nested at a lower level.

    % Push button callbacks. Each callback plots current_data in
    % the specified plot type.
    filename = '';
        function left_Callback(source,eventdata)
            resp(iresp).key = buttonName{1};
            resp(iresp).emotionSnd = filename;
            resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotionSnd);
            resp(iresp).emotionLbl = expe.(phase).condition(iresp).voicelabel;
            resp(iresp).congruent = strcmp(resp(iresp).emotionSnd, resp(iresp).emotionLbl);
            iresp = iresp + 1;
            [emotionvoices, filename] = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
            save('responses.mat', 'resp');
            Continue(emotionvoices);
        end

        function center_Callback(source,eventdata)
            if iresp == 0;
                centerBox.String = buttonName{2};
                set(rightBox, 'Visible', 'On');
                set(leftBox, 'Visible', 'On');
            else
                resp(iresp).key = buttonName{2};
                resp(iresp).emotionSnd = filename;
                resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotionSnd);
                resp(iresp).emotionLbl = expe.(phase).condition(iresp).voicelabel;
                resp(iresp).congruent = strcmp(resp(iresp).emotionSnd, resp(iresp).emotionLbl);
            end
            iresp = iresp + 1;
            [emotionvoices, filename] = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
            save('responses.mat', 'resp');
            Continue(emotionvoices);
        end

        function right_Callback(source,eventdata)
            resp(iresp).key = buttonName{3};
            resp(iresp).emotionSnd = filename;
            resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotionSnd);
            resp(iresp).emotionLbl = expe.(phase).condition(iresp).voicelabel;
            resp(iresp).congruent = strcmp(resp(iresp).emotionSnd, resp(iresp).emotionLbl);
            iresp = iresp + 1;
            [emotionvoices, filename] = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
            save('responses.mat', 'resp');
            Continue(emotionvoices);
        end
    
        function Continue(emotionvoices)
%             fprintf('%i %s', iresp, resp(iresp).emotionSnd)
            iresp
            if iresp == options.(phase).total_ntrials
                set(rightBox, 'Visible', 'Off');
                set(leftBox, 'Visible', 'Off');
                centerBox.String = 'THANK YOU';
                pause(5)
                close(gcf)
%                 return;
            end
        end
    
        function autoplay
            while iresp < options.(phase).total_ntrials
                iresp = iresp + 1;
                [emotionvoices, filename] = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
                resp(iresp).key = randi([1 3], 1);
                resp(iresp).emotionSnd = filename;
                resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotionSnd);
                resp(iresp).emotionLbl = expe.(phase).condition(iresp).voicelabel;
                resp(iresp).congruent = strcmp(resp(iresp).emotionSnd, resp(iresp).emotionLbl);
                save('responses.mat', 'resp');
                Continue(emotionvoices);
            end
        end

end

% playfile([soundDir emotionvoices(indexes(toPlay)).name])

function [emotionvoices, played] = playfile(iTrial, emotionvoices, expe, phase, options, soundDir)
    
    emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
    phaseVect = strcmp({emotionvoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);

    if isempty(emotionvoices(indexes)) % extend structure with missing files and redo selection
        nLeft = length(emotionvoices);
        tmp = files2play(classifyFiles(soundDir), phase);
        emotionvoices(nLeft + 1 : nLeft + length(tmp)) = tmp;
        clear tmp
        emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
        phaseVect = strcmp({emotionvoices.phase}, phase);
        possibleFiles = [emotionVect & phaseVect];
        indexes = 1:length(possibleFiles);
        indexes = indexes(possibleFiles);
    end
    
    isempty(emotionvoices(indexes))
    length(emotionvoices(indexes))
    
    toPlay = randperm(length(emotionvoices(indexes)),1);
    played = emotionvoices(indexes(toPlay)).name;
    [y, Fs] = audioread([soundDir emotionvoices(indexes(toPlay)).name]);
    player = audioplayer (y, Fs);
    playblocking (player);
    
    % remove just played file from list of possible sound files
    emotionvoices(indexes(toPlay)) = [];
end

function emotionvoices = files2play(emotionvoices, phase)

    emotionvoices = emotionvoices(strcmp({emotionvoices.phase}, phase));   

end

   
    


