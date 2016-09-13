function varargout = MCI_GUI(varargin)
close all
    
    phase = 'training';
%     phase = 'test';
    participant.name = 'test';
    if nargin > 1
        phase = varargin{1};
        participant = varargin{2};
    end

    fprintf('MCI %s phase \n', phase);
    
    %  Create and then hide the GUI as it is being constructed.
    widthFig = 1280;
    heightFig = 1024;
    sideButton = [350 290];
    if (widthFig /  sideButton(1)) < 3
        fprinft('images of contours are too wide for buttons, resize?')
    end
    if (heightFig /  sideButton(2)) < 3
        fprinft('images of contours are too tall for buttons, resize?')
    end
    startX = floor(rem(widthFig, sideButton(1)) / 2);
    startY = floor(rem(heightFig, sideButton(2)) / 2);
    f = figure('Position', [startX, startY, widthFig, heightFig]);
    sizeButton = [sideButton(1) sideButton(2)] ./ 2;
    xpos = linspace(startX, widthFig - sideButton(1) - startX, 3);
    ypos = linspace(startY, heightFig - sideButton(2) - startY, 3);
    iLoop = 0;
    [options] = MCI_options;
    for xButton = 1 : length(xpos)
        for yButton = 1 : length(ypos)
            iLoop = iLoop + 1;
            imgfiles = dir([options.locationImages '*_MCI' num2str(iLoop) '.jpg']);
            tmp = imread([options.locationImages imgfiles(1).name]);
            a = tmp;
            a(:, :, 2) = tmp;
            a(:, :, 3) = tmp;
            hsurf(iLoop).b = uicontrol('Style','pushbutton', ...
                'CData', a, ...
                'Tag', imgfiles(1).name(1 : strfind(imgfiles(1).name, '_')-1), ...
                'Position',[xpos(xButton) ypos(yButton), ...
                sideButton(1), sideButton(2)], ... 
                'BackgroundColor', 'white', ...
            'Callback', @processKeyButtons);
        end
    end

%% set up experiment
    dir2save = '';
    dir2save = '~/Results/MCI/';
    % check if part of the experiment has been performed already
    runBefore = dir([dir2save phase '_MCI_' participant.name '.mat']);
    istim = 1;
    if isempty(runBefore)
        [stimuli, nBlocks] = MCI_makeStimuli(phase);
    else
%         load([runBefore.folder '/' runBefore.name]);
        load([dir2save runBefore.name]);
        nBlocks = floor(sum([stimuli.done] == 1) / 27); % 27 = nContours * nRepetitions;
        istim = find([stimuli.done] == 0, 1);
        if isempty(istim)
            fprintf('MCI %s phase COMPLETED\n', phase);
            clear all
            close all
            return;
        end
    end
    nTrialsPerBlock = length(stimuli) / nBlocks;

    nStim = length(stimuli);
%     stimuli = stimuli(randperm(nStim));
    if ~ strcmp(participant.name, 'test')
        h = warndlg('Pressing START will begin the task','READY TO GO?', 'modal');
        uiwait(h);
    end
    
    f.Visible = 'on';
    pause(1);
    blocksCompleted = 0;
    
    playMCI
    
    function playMCI
        if istim > nStim
            fprintf('MCI %s phase COMPLETED\n', phase);
            clear all
            close all
            return;
        end
        [notes2play, fs] = MCI_makeContour(stimuli(istim));
        p = audioplayer(notes2play, fs);
        playblocking(p)
        if ~ strcmp(participant.name, 'test')
            uiwait(gcf);
        else
            stimuli(istim).response = randi([1, 9]);
            fprintf('trNum %i | stim = %s -- resp = %i\n', istim, ...
                stimuli(istim).mciProfile, stimuli(istim).response);
            stimuli(istim).acc = randi([0, 1]);
            stimuli(istim).done = 1;
            save([dir2save phase, '_MCI_' participant.name '.mat'], 'stimuli');
            istim = istim + 1;
            playMCI
        end
    end

    function processKeyButtons(source, ~)
%         val = source.Value;
%         maps = source.String;
        if isempty(source.String)
            fprintf('trNum %i | stim = %s -- resp = %s\n', istim, ...
                stimuli(istim).mciProfile, source.Tag);
            stimuli(istim).response = source.Tag;
            stimuli(istim).done = 1;
            if strcmp(stimuli(istim).mciProfile, source.Tag)
                stimuli(istim).acc = 1;
            end
            save([dir2save phase, '_MCI_' participant.name '.mat'], 'stimuli');
            pause(.25);
            % %% break
            if mod(istim, nTrialsPerBlock) == 0
                blocksCompleted = blocksCompleted + 1;
                htmp = warndlg(...
                    sprintf('Please take a break/n/nPressing START to continue with the task', 'modal'),...
                    sprintf('%i of %i blocks completed', blocksCompleted, nBlocks));
                uiwait(htmp);
            end
            istim = istim + 1; % do next trial
            playMCI
        else
            switch source.String
                case 'Start'
                    disp('Start')
                case 'Finished'
                    disp('Finished')
                otherwise 
                    disp('This buttonpress option is not implemented')
            end
        end   
        uiresume(gcbf)

    end
    
    
end
