function nva_interface(stimulus, options, participant, pathsToAdd)

    for iPath = 1 : length(pathsToAdd)
        addpath(pathsToAdd{iPath})
    end
    
    screen = monitorSize;
    screen.xCenter = round(screen.width / 2);
    screen.yCenter = round(screen.heigth / 2);

    disp.width = 900; % minBottonWidth * length(stimulus) + 100; % 100 is an arbitrary boundary
    disp.heigth = 400;
    disp.Left = screen.left + screen.xCenter - (disp.width / 2);

    disp.Up = screen.bottom + screen.yCenter - (disp.heigth / 2);

    f = figure('Visible','off','Position',[disp.Left, disp.Up, disp.width, disp.heigth], ...
        'Toolbar', 'none', 'Menubar', 'none', 'NumberTitle', 'off');

    % globals
    list = fieldnames(stimulus);
    iList = 1;
    iStim = 1;
    continueExp = true;
    
    %  Construct the bottons.
    phonemesNum = {'first', 'second', 'third'};
    buttonName = {'zero', phonemesNum{:}, 'ALL'}; % words
    nButtons = length(buttonName);
    minBottonWidth = 25;
    nLettersXbutton = cellfun('length', buttonName); % however 2,3,4 are only letters not first, second, third
    nLettersXbutton(2:4) = 2; % i.e. maximmaly 2 letters
    bottonWidth = minBottonWidth + minBottonWidth * nLettersXbutton;
    bottonHeight= 80;
    bottonYpos = round(disp.heigth*3/4) - round(bottonHeight / 2);
    for iButton = 1 : nButtons
        Box.(buttonName{iButton}) = uicontrol('Style','pushbutton','String', buttonName{iButton},...
            'Position',[(disp.width * iButton/(nButtons + 1) - round(bottonWidth(iButton) / 2)), ...
                bottonYpos, bottonWidth(iButton), bottonHeight],...
            'Callback',@keysCallback, 'Visible', 'On', 'FontSize', 20);%, 'enable', 'off');
    end
    
    set(Box.zero, 'BackgroundColor', 'red');
    set(Box.ALL, 'BackgroundColor', 'green');
    
    currentWord = strsplit(stimulus.(list{iList}).words2Display{iStim}, '#'); % words
%     currentWord = {'#','#','#'};
    for phoneme = 1 : length(currentWord)
        Box.(phonemesNum{phoneme}).String = currentWord{phoneme};
    end
    
    bottonWidth = minBottonWidth + minBottonWidth * length('  START  ');
    Box.continue = uicontrol('Style','pushbutton','String', 'START',...
            'Position',[(disp.width/2 - round(bottonWidth/2)), bottonYpos - 2 * bottonHeight, ...
                bottonWidth, bottonHeight],...
            'Callback',@(hObject,callbackdata) continueCallback, 'Visible', 'On', 'FontSize', 20);
    
    % Initialize the GUI.
    % Change units to normalized so components resize automatically.
    f.Units = 'normalized';
    NAMES = fieldnames(Box);
    for iButton = 1 : length(NAMES)
        Box.(NAMES{iButton}).Units = 'normalized';
    end

    % Assign the GUI a name to appear in the window title.
    f.Name = 'NVA task dbSPL';
    % Move the GUI to the center of the screen.
    movegui(f,'center')
    
    % load noise 
    [noise, fs] = audioread([options.wordsFolder '00Spraakruis.wav']);
    rmsM = rms(noise);
    fprintf('%s noise attenuation = %i\n', list{iList}, stimulus.(list{iList}).TMR);
    % Make the GUI visible.
    f.Visible = 'on';
    
    Fs = 8000;
    recorder = audiorecorder(Fs,16,1);
    stopRecording = false;
    
    ipush = 1;
    repeatedPhonemes = {''};
    iResp = 1;
    responses.NVAstarts = datetime('now', 'InputFormat', 'dd-mmm-yyyy HH:mm:ss');
    
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
    
    
    function keysCallback(source, ~)
        
        if strcmp(participant.name, 'test')
            randPicked = randi([1 length(buttonName)]);
            repeatedPhonemes{1} = Box.(buttonName{randPicked}).String;
            continueCallback
        else
            repeatedPhonemes{ipush} = source.String;
            ipush = ipush + 1;
            switch source.String
                case Box.zero.String
                    set(Box.zero, 'enable', 'off');
                case Box.ALL.String
                    set(Box.ALL, 'enable', 'off');
                case Box.first.String
                    set(Box.first, 'enable', 'off');
                case Box.second.String
                    set(Box.second, 'enable', 'off');
                case Box.third.String
                    set(Box.third, 'enable', 'off');
                otherwise
                    fprintf('something odd with setting off buttons\n')
            end
            set(Box.continue, 'enable', 'on');
        end % if test subject_name
        stopRecording = true;
    end % function call

    function continueCallback
        
        %% store responses
        if ~isempty(repeatedPhonemes{1})
            
            filename = [options.responsesFolder 'nva_' participant.name '.mat'];
            if exist(filename, 'file') 
                load(filename)
            else
                responses.listsOrder = {};
            end
            
            attempt = 1;
            if exist('responses', 'var') && isfield(responses, list{iList})
                attempt = length(responses.(list{iList}));
                if length(responses.(list{iList})(attempt).scores) == ...
                        length(stimulus.(list{iList}).wordsLists)
                    attempt = attempt + 1;
                end
            end
            
            responses.(list{iList})(attempt).scores{iResp} = repeatedPhonemes;
            responses.(list{iList})(attempt).word(iResp) = stimulus.(list{iList}).wordsLists(iResp);
            responses.(list{iList})(attempt).timeFromStart(iResp) = ...
                datetime('now', 'InputFormat', 'dd-mmm-yyyy HH:mm:ss'); % milliseconds(... - NVAstarts) to extract;
            if strcmp(repeatedPhonemes, 'ALL')
                responses.(list{iList})(attempt).phonemes{iResp} = [strsplit(stimulus.(list{iList}).words2Display{iResp}, '#')];
            else
                responses.(list{iList})(attempt).phonemes{iResp} = responses.(list{iList})(attempt).scores(iResp);
            end
            responses.listsOrder = {responses.listsOrder{:} list{iList}};
            
            save(filename, 'responses');
            if stopRecording
                stop(recorder);
                y = getaudiodata(recorder);
                audiowrite([options.recordingsFolder list{iList} '_' ... 
                    stimulus.(list{iList}).wordsLists{iResp} '.wav'], y, Fs)
                stopRecording = ~stopRecording;
            end
            
            iResp = iResp + 1;
            if (iResp > length(stimulus.(list{iList}).wordsLists))
                iResp = 1;
            end
     
            % return button status to ON
            for phoneme = 1 : length(repeatedPhonemes)
               switch repeatedPhonemes{phoneme}
                    case Box.zero.String
                        set(Box.zero, 'enable', 'on');
                    case Box.ALL.String
                        set(Box.ALL, 'enable', 'on');
                    case Box.first.String
                        set(Box.first, 'enable', 'on');
                    case Box.second.String
                        set(Box.second, 'enable', 'on');
                    case Box.third.String
                        set(Box.third, 'enable', 'on');
                    otherwise
                        fprintf('something odd with setting off buttons\n')
                end
            end
            
            %% update the button names
            if (iStim > length(stimulus.(list{iList}).wordsLists)) && (iList == length(list))
                fprintf('finished\n')
                continueExp = false;
                uiresume();
                close(f)
                return
            else
                if iStim > length(stimulus.(list{iList}).wordsLists) && (iList + 1) <= length(list)
                    currentWord = strsplit(stimulus.(list{iList+1}).words2Display{1}, '#');
                else
                    currentWord = strsplit(stimulus.(list{iList}).words2Display{iStim}, '#');
                end
                for phoneme = 1 : length(phonemesNum)
                    Box.(phonemesNum{phoneme}).String = currentWord{phoneme};
                end
                repeatedPhonemes = {''};
                ipush = 1;
            end
            if (iStim > length(stimulus.(list{iList}).wordsLists)) && (iList ~= length(list))
                iStim = 1;
                iList = iList + 1;
                fprintf('%s noise attenuation = %i\n', list{iList}, stimulus.(list{iList}).TMR);
                pause(.1);
            end
            
        end
        
        
%% commands independent of whether phonemes have been clicked or not
        Box.continue.String = sprintf('PLAYING = %d', iStim);
        for iButton = 1 : length(buttonName)
            set(Box.(buttonName{iButton}), 'enable', 'off');
        end
        [y, fs] = audioread([options.wordsFolder stimulus.(list{iList}).wordsLists{iStim} '.wav']);
        if ~ options.noise
            what2play = audioplayer([y(:, 1) y(:, 1)], fs);% make stereo sound
        else
            % christina plays stimuli with noise at different levels
            target = remove_silence(y(:, 1), fs); 
            rmsT = rms(target);
            silenceInFs = floor(0.25*fs);
%             silence_end = length(target)+ 2 * silenceInFs;
            target = [zeros(silenceInFs, 1); target; zeros(silenceInFs, 1)]; 
            if stimulus.(list{iList}).TMR == Inf
                masker = noise(1 : length(target))./rmsM.*(rmsT/10^(stimulus.(list{iList}).TMR/20));
                addpath('../lib/MatlabCommonTools/');
                masker = cosgate(masker, fs, 50e-3); %50ms cosine ramp to both beginning and end of masker signal.
                xOut = (target+masker)*10^(-options.attenuation_dB/20);
            else
                xOut = (target)*10^(-options.attenuation_dB/20);
            end
            what2play = audioplayer([xOut], fs);
        end
%         playblocking(what2play); % otherwise we cannot record
        play(what2play);
        
        if ~strcmp(participant.name, 'test')
            uiresume();
            record(recorder)
        end
        
        % this is because we want to asynchronously play and record, but we
        % need to wait that the sound is played before continuing
        while what2play.isplaying
            pause(.1);
        end
        
        set(Box.continue, 'enable', 'off');
        
%% update buttons status
        iStim = iStim + 1;
        Box.continue.String = 'NEXT';
        if (iStim > length(stimulus.(list{iList}).wordsLists)) && (iList == length(list))
            Box.continue.String = sprintf('FINISHED');
        end
        for iButton = 1 : length(buttonName)
            set(Box.(buttonName{iButton}), 'enable', 'on');
        end
        if strcmp(participant.name, 'test')
            pause(.5)
            keysCallback
        end
            
    end % function continueCallback
end % interface