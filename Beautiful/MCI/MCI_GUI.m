function MCI_GUI(participant)
%% set up experiment
    dir2save = '';
    dir2save = '~/Results/MCI/';
    % check if part of the experiment has been performed already
    runBefore = dir([dir2save 'MCI_' participant.name '.mat']);
    istim = 0;
    phases = {'training', 'test'};
    iphase = 1;
    if isempty(runBefore)
        [stimuli, nBlocks, trialsPerBlock] = MCI_makeStimuli;
        currentBlock = 1;
    else
%         load([runBefore.folder '/' runBefore.name]); % not available in
%         2016a
        load([dir2save runBefore.name]);
        % check which phase was completed
        while true
            if iphase > 2
                break
            end
            total = sum(strcmp({stimuli.phase}, phases{iphase}));
            completed = sum([stimuli(strcmp({stimuli.phase}, phases{iphase})).done] == 1);
            fprintf('%s', phases{iphase});
            if total ~= completed 
                fprintf(' NOT completed\n');
                break 
            end
            fprintf('completed\n');
            iphase = iphase + 1;
        end        
        if iphase > 2
            fprintf('Experiment completed\n')
            return
        end
        trialsPerBlock = 27;
        nBlocks(iphase) = round(length(stimuli(strcmp({stimuli.phase}, phases{iphase}))) / trialsPerBlock);
        currentBlock = ceil(sum([stimuli(strcmp({stimuli.phase}, phases{iphase})).done] == 1) / trialsPerBlock); % 27 = nContours * nRepetitions;
%         istim = find([stimuli(strcmp({stimuli.phase}, phases{iphase})).done] == 0, 1);
        
    end
    nTrialsPerBlock = length(stimuli(strcmp({stimuli.phase}, phases{iphase}))) / nBlocks(iphase);
%     nTrialsPerBlock = 3;
%     disp(nBlocks);
    fprintf('MCI %s phase \n', phases{iphase});
    
%%  Create and then hide the GUI as it is being constructed.
    widthFig = 1280;
    heightFig = 1024;
    sideButton = [364 304]; % adjusted to leave room for the feedback
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
    buttonLabel = {'','','','', sprintf('Start block %i of %i blocks (%s)', ...
        currentBlock, nBlocks(iphase),  stimuli(istim + 1).phase), '','', '',''};
% +1 because Subscript indices must either be real positive integers or logicals.
    responsesLabels = {};
    for xButton = 1 : length(xpos)
        for yButton = 1 : length(ypos)
            iLoop = iLoop + 1;
            imgfiles = dir([options.locationImages '*_MCI' num2str(iLoop) '.jpg']);
            responsesLabels{iLoop} = imgfiles(1).name(1 : strfind(imgfiles(1).name, '_')-1);
            enabled = 'off';
            if iLoop == 5
                enabled = 'on';
            end
            hsurf(iLoop).b = uicontrol('Style','pushbutton', ...
                'String', buttonLabel{iLoop}, ...
                'Position',[xpos(xButton) ypos(yButton), ...
                sideButton(1), sideButton(2)], ... 
                'BackgroundColor', 'white', ...
                'Enable', enabled, ...
            'Callback', @processKeyButtons);
 
        end
    end

%% user interaction
%     nStim = length(stimuli(strcmp({stimuli.phase}, phases{iphase})));
    nStim = length(stimuli);
    if strcmp(participant.name, 'test')
       playMCI 
    end
    
    f.Visible = 'on';
    pause(.5);
    blocksCompleted = 0;
    continueExp = true;
    while continueExp
        if continueExp == false
            fprintf('Ciao Ciao \n');
            return
        end
        if strcmp(participant.name, 'test')
            keysCallback
        else
            uiwait;
        end
    end % while loop all trials
  
    
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
        istim = find([stimuli.done] == 0, 1);
%         if istim > nStim
        if isempty(istim) 
            fprintf('MCI COMPLETED\n');
            iLoop = 0;
            buttonLabel = {'','','','', ...
                sprintf('Testing Finished. Thank you!!'), '','', '',''};
            for xButton = 1 : length(xpos)
                for yButton = 1 : length(ypos)
                    iLoop = iLoop + 1;
                    hsurf(iLoop).b.CData = [];
                    hsurf(iLoop).b.String = buttonLabel{iLoop};
                    
                end
            end
            hsurf(5).b.Enable = 'on';
            save([dir2save 'MCI_' participant.name '.mat'], 'stimuli');
            pause(2)
            continueExp = false;
            return
        end
        if istim > 1 & ~strcmp(stimuli(istim).phase, stimuli(istim-1).phase)
            % switch from training to test
            iphase = 2; % in case that it is not set before
%             iLoop = 0;
%             buttonLabel = {'','','','', ...
%                 sprintf('Training Finished. Start testing!!'), '','', '',''};
%             for xButton = 1 : length(xpos)
%                 for yButton = 1 : length(ypos)
%                     iLoop = iLoop + 1;
%                     hsurf(iLoop).b.CData = [];
%                     hsurf(iLoop).b.String = buttonLabel{iLoop};
%                 end
%             end
%             hsurf(5).b.Enable = 'on';
%         else  % if istim > 1 & ~strcmp(stimuli(istim).phase, stimuli(istim-1).phase)
        end
%         disp(pwd)
            [notes2play, fs] = MCI_makeContour(stimuli(istim));
            p = audioplayer(notes2play, fs);
            playblocking(p)
            nButtons = length(hsurf);
            for iButton = 1 : nButtons
                hsurf(iButton).b.Enable = 'on';
            end
            if ~ strcmp(participant.name, 'test')
                uiwait(gcf);
            else
            % automatic player    
                stimuli(istim).response = randi([1, 9]);
                fprintf('trNum %i | stim = %s -- resp = %i\n', istim, ...
                    stimuli(istim).mciProfile, stimuli(istim).response);
                stimuli(istim).acc = randi([0, 1]);
                stimuli(istim).done = 1;
                stimuli(istim).time = datetime('now', 'InputFormat', 'dd-mmm-yyyy HH:mm:ssss'); % extract as: i.e. stimuli(istim).time.Second
                save([dir2save 'MCI_' participant.name '.mat'], 'stimuli');
                playMCI
            end
%         end % if istim > 1 & ~strcmp(stimuli(istim).phase, stimuli(istim-1).phase)
    end

    function processKeyButtons(source, ~)
        if isempty(source.String)
%             disp(istim)
            % disable response buttons
            nButtons = length(hsurf);
            for iButton = 1 : nButtons
                hsurf(iButton).b.Enable = 'off';
            end
            fprintf('trNum %i | stim = %s -- resp = %s\n', istim, ...
                stimuli(istim).mciProfile, source.Tag);
            stimuli(istim).response = source.Tag;
            stimuli(istim).done = 1;
            if strcmp(stimuli(istim).mciProfile, source.Tag)
                stimuli(istim).acc = 1;
            end
            save([dir2save 'MCI_' participant.name '.mat'], 'stimuli');
            
            if strcmp(phases{iphase}, 'training') && ~ stimuli(istim).acc 
                giveFeedback(source.Tag)
            end
            pause(.25);
            % %% break
            if mod(istim, nTrialsPerBlock) == 0
                blocksCompleted = blocksCompleted + 1;
                iLoop = 0;
                % +1 because we want to go to the next block
                currentBlock = (ceil(sum([stimuli(strcmp({stimuli.phase}, ...
                    phases{iphase})).done] == 1) / nTrialsPerBlock)) + 1; 
                buttonLabel = {'','','','', sprintf('Start block %i of %i blocks (%s)', ...
                    currentBlock, nBlocks(iphase), stimuli(istim).phase), '','', '',''};
                for xButton = 1 : length(xpos)
                    for yButton = 1 : length(ypos)
                        iLoop = iLoop + 1;
                        hsurf(iLoop).b.CData = [];
                        hsurf(iLoop).b.String = buttonLabel{iLoop};
                    end
                end
                hsurf(5).b.Enable = 'on';
            else
                % do next trial
                playMCI
            end % else just wait for the next button press
        else
            if strfind(source.String, 'Start')
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
                playMCI
            end
        end
        uiresume(gcbf)
        if istim > nStim
            return;
        end
    end

end % function MCI_GUI

