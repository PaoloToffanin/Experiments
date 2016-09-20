function varargout = MCI_GUI(varargin)
close all
    
    phase = 'training';
%     phase = 'test';
    participant.name = 'paolo';
%     participant.name = 'test';
    if nargin > 1
        phase = varargin{1};
        participant = varargin{2};
    end

    fprintf('MCI %s phase \n', phase);
    
%% set up experiment
    dir2save = '';
    dir2save = '~/Results/MCI/';
    % check if part of the experiment has been performed already
    runBefore = dir([dir2save phase '_MCI_' participant.name '.mat']);
    istim = 0;
    if isempty(runBefore)
        [stimuli, nBlocks] = MCI_makeStimuli(phase);
        currentBlock = 1;
    else
%         load([runBefore.folder '/' runBefore.name]);
        load([dir2save runBefore.name]);
        % nBlocks = floor(sum([stimuli.done] == 1) / 27); % 27 = nContours * nRepetitions;
        nBlocks = length(stimuli) / 27;
        currentBlock = ceil(sum([stimuli.done] == 1) / 27); % 27 = nContours * nRepetitions;
        istim = find([stimuli.done] == 0, 1);
        if isempty(istim)
            fprintf('MCI %s phase COMPLETED\n', phase);
            clear all
            close all
            return;
        end
    end
    nTrialsPerBlock = length(stimuli) / nBlocks;
    
    %  Create and then hide the GUI as it is being constructed.
    widthFig = 1280;
    heightFig = 1024;
%     sideButton = [350 290];
    sideButton = [364 304]; % adjuste to leave room for the feedback
    if (widthFig /  sideButton(1)) < 3
        fprinft('images of contours are too wide for buttons, resize?')
    end
    if (heightFig /  sideButton(2)) < 3
        fprinft('images of contours are too tall for buttons, resize?')
    end
    startX = floor(rem(widthFig, sideButton(1)) / 2);
    startY = floor(rem(heightFig, sideButton(2)) / 2);
    f = figure('Visible','off','Position',[startX, startY, widthFig, heightFig], ...
        'Toolbar', 'none', 'Menubar', 'none', 'NumberTitle', 'off');

    
    
    sizeButton = [sideButton(1) sideButton(2)] ./ 2;
    xpos = linspace(startX, widthFig - sideButton(1) - startX, 3);
    ypos = linspace(startY, heightFig - sideButton(2) - startY, 3);
    iLoop = 0;
    [options] = MCI_options;
    buttonLabel = {'','','','', sprintf('Start block %i of %i', currentBlock, nBlocks), '','', '',''};
    responsesLabels = {};
    for xButton = 1 : length(xpos)
        for yButton = 1 : length(ypos)
            iLoop = iLoop + 1;
            imgfiles = dir([options.locationImages '*_MCI' num2str(iLoop) '.jpg']);
            responsesLabels{iLoop} = imgfiles(1).name(1 : strfind(imgfiles(1).name, '_')-1);
%             tmp = imread([options.locationImages imgfiles(1).name]);
%             a = tmp;
            % this cannot be used because the images do not have all the
            % same size
%             a(:, :, 2, iLoop) = tmp;
%             a(:, :, 3, iLoop) = tmp;
%                 'CData', a, ....
%                 'Tag', imgfiles(1).name(1 : strfind(imgfiles(1).name, '_')-1), ...
%                 'FontSize', 28, ...
%                 'FontWeight', 'bold', ...
            hsurf(iLoop).b = uicontrol('Style','pushbutton', ...
                'String', buttonLabel{iLoop}, ...
                'Position',[xpos(xButton) ypos(yButton), ...
                sideButton(1), sideButton(2)], ... 
                'BackgroundColor', 'white', ...
            'Callback', @processKeyButtons);
 
        end
    end


    nStim = length(stimuli);
%     stimuli = stimuli(randperm(nStim));
%     if ~ strcmp(participant.name, 'test')
%         h = warndlg('Pressing START will begin the task','READY TO GO?', 'modal');
%         uiwait(h);
%     end
    if strcmp(participant.name, 'test')
        istim = istim + 1;
       playMCI 
    end
    
    f.Visible = 'on';
    pause(.5);
    blocksCompleted = 0;
    
    function giveFeedback(responseGiven)
%         correctAns = strcmp(responsesLabels, stimuli(istim).mciProfile);
%         actualAnswer = strcmp(responsesLabels, responseGiven);
        hsurf(strcmp(responsesLabels, responseGiven)).b.BackgroundColor = 'red';
        pause(1)
        hsurf(strcmp(responsesLabels, stimuli(istim).mciProfile)).b.BackgroundColor = 'green';
        pause(1)
        hsurf(strcmp(responsesLabels, stimuli(istim).mciProfile)).b.BackgroundColor = 'white';
        hsurf(strcmp(responsesLabels, responseGiven)).b.BackgroundColor = 'white';
        pause(.5)
    end

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
        
        if isempty(source.String)
            fprintf('trNum %i | stim = %s -- resp = %s\n', istim, ...
                stimuli(istim).mciProfile, source.Tag);
            stimuli(istim).response = source.Tag;
            stimuli(istim).done = 1;
            if strcmp(stimuli(istim).mciProfile, source.Tag)
                stimuli(istim).acc = 1;
            end
            save([dir2save phase, '_MCI_' participant.name '.mat'], 'stimuli');
            
            if ~ stimuli(istim).acc 
                giveFeedback(source.Tag)
            end
            pause(.25);
            % %% break
            if mod(istim, nTrialsPerBlock) == 0
                blocksCompleted = blocksCompleted + 1;
                iLoop = 0;
                buttonLabel = {'','','','', sprintf('Start block %i of %i',...
                    blocksCompleted, nBlocks), '','', '',''};
                for xButton = 1 : length(xpos)
                    for yButton = 1 : length(ypos)
                        iLoop = iLoop + 1;
                        hsurf(iLoop).b.CData = [];
                        hsurf(iLoop).b.String = buttonLabel{iLoop};
                    end
                end
%                 uiwait(htmp);
            else
                % do next trial
                istim = istim + 1; 
                playMCI
            end % else just wait for the next button press
        else
%             switch source.String
            if strfind(source.String, 'Start')
%                 case {'START', 'BREAK'}
                % put images on the buttons
                iLoop = 0;
                for xButton = 1 : length(xpos)
                    for yButton = 1 : length(ypos)
                        iLoop = iLoop + 1;
                        imgfiles = dir([options.locationImages '*_MCI' num2str(iLoop) '.jpg']);
                        tmp = imread([options.locationImages imgfiles(1).name]);
                        a = tmp;
                        a(:, :, 2) = tmp;
                        a(:, :, 3) = tmp;
                        hsurf(iLoop).b = uicontrol('Style','pushbutton', ...
                            'String', [], ...
                            'Tag', imgfiles(1).name(1 : strfind(imgfiles(1).name, '_')-1), ...
                            'Position',[xpos(xButton) ypos(yButton), ...
                            sideButton(1), sideButton(2)], ...
                            'CData', a, ....
                            'BackgroundColor', 'white', ...
                            'Callback', @processKeyButtons);
                    end
                end
                pause(.5);
                istim = istim + 1;
                playMCI
%                 case 'Finished'
%                     disp('Finished')
%                 otherwise 
%                     disp('This buttonpress option is not implemented')
            end
        end   
        uiresume(gcbf)

    end
    
    
end
