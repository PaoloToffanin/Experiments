function varargout = mci_GUI(varargin)
close all

    subID = 'test';
     
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
    for xButton = 1 : length(xpos)
        for yButton = 1 : length(ypos)
            iLoop = iLoop + 1;
            imgfiles = dir(['*_MCI' num2str(iLoop) '.jpg']);
            tmp = imread(imgfiles(1).name);
            a = tmp;
            a(:, :, 2) = tmp;
            a(:, :, 3) = tmp;
            hsurf(iLoop).b = uicontrol('Style','pushbutton', ...
                'CData', a, ...
                'Tag', imgfiles(1).name(1 : strfind(imgfiles(1).name, '_')-1), ...
                'Position',[xpos(xButton) ypos(yButton), ...
                sideButton(1), sideButton(2)], ... 
            'Callback', @processKeyButtons);
        end
    end

%% set up experiment
    stimuli = mci_makeStimuli;
    istim = 1;
    nStim = length(stimuli);
    stimuli = stimuli(randperm(nStim));
    
    f.Visible = 'on';
    pause(1);
    playMCI
    
    function playMCI
        [notes2play, fs] = mci_makeContour(stimuli(istim));
        p = audioplayer(notes2play, fs);
        playblocking(p)
        uiwait(gcf);
        
    end

    function processKeyButtons(source, ~)
%         val = source.Value;
%         maps = source.String;
        if isempty(source.String)
            fprintf('trNum %i | stim = %s -- resp = %s\n', istim, ...
                stimuli(istim).mciProfile, source.Tag);
            stimuli(istim).response = source.Tag;
            if strcmp(stimuli(istim).mciProfile, source.Tag)
                stimuli(istim).acc = 1;
            end
%             save(['~/Results/MCI/' 'mci_' subID '.mat'], 'stimuli');
            save(['' 'mci_' subID '.mat'], 'stimuli');
            pause(.25);
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
