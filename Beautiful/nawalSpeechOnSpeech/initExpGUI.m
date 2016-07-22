function h = initExpGUI(expe,options)
   
    h = struct();
    
    scrsz = get(0,'MonitorPositions');
    
    if size(scrsz,1) > 1
        scrsz = scrsz(2,:); %select the second row which should correspond to the experimenter's screen.
    end
    
    fntsze = 20;
    
    if ~is_test_machine
        left = scrsz(1); bottom = scrsz(2); width = scrsz(3); height = scrsz(4);
    else
          left = -1024; bottom=0; width=1024; height=768;
        %left = scrsz(1); bottom = scrsz(2); width = scrsz(3); height = scrsz(4);
        
    end
    
    scrsz = [left, bottom, width, height];
    %scrsz = [-1024 0 1024 10];
    n_rows = 1; 
    n_cols = 3; 
    grid_sz = [n_cols, n_rows]*300;
    
    %Progress bar params
    h.main_text_color = [1 1 1]*.9;
    h.background_color = [.6 .6 .6];
    h.progress_bar_color = [.5 .8 .5];
    

    h.f = figure('Visible', 'off', 'Position', scrsz, ...
        'Toolbar', 'none', 'Menubar', 'none', 'NumberTitle', 'off');
    
    % Progress bar
    h.waitbar = axes('Units', 'pixel', 'Position', [width/2-300, height/2+50, 600, 25], 'Box', 'off', ...%height-50
        'XColor', 'w', 'YColor', 'w', 'XTick', [], 'YTick', []);
    h.waitbar_legend = uicontrol('Style', 'text', 'Units', 'pixel', 'Position', [width/2-300, height/2+150, 600, 50], ...%height-101
        'HorizontalAlignment', 'center', 'FontSize', fntsze, 'ForegroundColor', h.main_text_color, 'BackgroundColor', h.background_color);

    %Prepare a flag that makes expe_main wait until you are ready to proceed to the next trial.
    h.continue = uicontrol('Style','togglebutton',...
                'Value',0,'Position',[30 20 100 30],'Visible','off'); 
    
    %Define buttons:
    h.Box.continue = uicontrol('Style','pushbutton','String', 'CONTINUE',...
            'Position',[width/2-grid_sz(1)/50, height/2-grid_sz(2), grid_sz(2), 100],...
            'Enable','off', 'Visible', 'On');
    h.Box.play = uicontrol('Style','pushbutton','String', 'PLAY',...
            'Position',[width/2-grid_sz(1)/2, height/2-grid_sz(2), grid_sz(2), 100], 'Visible', 'On');
    
    %Actions:
    h.init_buttons = @(s) init_buttons(s);
    h.init_continue = @(s,i,trial) init_continue(s,i,trial);
    h.init_playbutton = @(s,fs) init_playbutton(s,fs);   
    h.set_progress = @(t, i, n) set_progress(t, i, n);
    
    h.set_contFlag = @(x) set(h.continue,'Value',x);
    h.get_contFlag = @() get(h.continue,'Value');
    

    % Assign the GUI a name to appear in the window title.
    h.f.Name = 'Speech on Speech: Experimenter GUI';
    
    
    % Make the GUI visible.
    movegui(h.f,'center');
    h.f.Visible = 'on';
    
    
    %% Helper functions:
    function init_buttons(sentence)
        
        buttonName = strsplit(sentence, ' '); % words
        
        %Check if white spaces remain because this might cause an error
        %later:
        problematic = strcmp(buttonName,'');
        
        if sum(problematic) > 0
            
         buttonName = buttonName(~problematic);   
            
        end
        
        problematic2 = strfind(buttonName,'-');
        
        
        if ~isempty([problematic2{:}])
            
            button_index = find(~cellfun(@isempty,problematic2));
            dash_loc = problematic2{button_index};
            buttonName{button_index} = buttonName{button_index}([1:dash_loc-1,dash_loc+1:end]);   
            
        end
        
        nButtons = length(buttonName);

        
        xPos = (0.05:0.1:1.5)';
        yPos = 0.3;
        [X,Y] = meshgrid(xPos,yPos);

        buttonwidth = 0.08;
        buttonheight = 0.08;
        for iButton = 1:nButtons
            try
               h.Box.(buttonName{iButton}) = uicontrol('Style','togglebutton','Units','normalized',...
                          'String', buttonName{iButton},...
                          'Position',[X(iButton),Y(iButton),buttonwidth,buttonheight],'Value', 0, 'Visible', 'On');
            catch
                disp('----------');
                disp('Sentence:');
                disp(sentence);
                disp('----------');
                
            end
        end 
        
    end

    function init_continue(sentence,i_condition,trial)
        
        set(h.Box.continue,'Callback',@(hObject,callbackdata) continueCallback(expe,options,sentence,i_condition,trial));
        
    end

    function init_playbutton(stimulus,fs)
        
       set(h.Box.play,'Callback',@(hObject,callbackdata) playSnd(stimulus,fs));     
        
    end

    function set_progress(t, i, n)

        if n>0
            set(h.waitbar_legend, 'String', sprintf('%s: %d/%d', t, i, n));
            fill([0 1 1 0] * i/n, [0 0 1 1], h.progress_bar_color, 'Parent', h.waitbar, 'EdgeColor', 'none');
        else
            set(h.waitbar_legend, 'String', t);
            fill([0 1 1 0] * 0, [0 0 1 1], h.progress_bar_color, 'Parent', h.waitbar, 'EdgeColor', 'none');
        end
        set(h.waitbar, 'XColor', 'w', 'YColor', 'w', 'XTick', [], 'YTick', [], 'Xlim', [0 1], 'YLim', [0 1]);


    end

    %% Callbacks:

    function continueCallback(expe,options,sentence,i_condition,trial)
        
        stop(h.recObj);
        disp('End of Recording.');
        trial_dur = toc();
        y = getaudiodata(h.recObj);
        fs = h.recObj.SampleRate;
        
%         %check if 'results' field exists:
%         filename = options.res_filename;
%         vars = whos('-file',filename);
%         results_exist = ismember('results', {vars.name});
        
        words = strsplit(sentence, ' ');
        
        %Check if white spaces remain because this might cause an error
        %later:
        problematic = strcmp(words,'');
        
        if sum(problematic) > 0
            
         words = words(~problematic);   
            
        end
        
        problematic2 = strfind(words,'-');
        
        
        if ~isempty([problematic2{:}])
            
            word_index = find(~cellfun(@isempty,problematic2));
            dash_loc = problematic2{word_index};
            words{word_index} = words{word_index}([1:dash_loc-1,dash_loc+1:end]);   
            
        end
        
        repeatedWords = [];
        
        for i = 1:length(words)
            
            if h.Box.(words{i}).Value == 1
                if isempty(repeatedWords)
                    repeatedWords{1} = words{i};
                else
                    repeatedWords{end+1} = words{i};
                end
            end
            
        end
        
        %check if 'results' field exists:
%         filename = [options.result_path  options.res_filename];
        if exist([options.result_path  options.res_filename], 'file')
% N        if results_exist
%             load(filename, 'results') 
            load([options.result_path options.res_filename], 'results')
            results(i_condition).words = repeatedWords;
            results(i_condition).sentence = sentence;
            results(i_condition).nwords_correct = length(repeatedWords);
            
            results(i_condition).label = options.test.voices(trial.dir_voice).label;
            results(i_condition).dir_voice = trial.dir_voice;
            results(i_condition).vocoder = trial.vocoder;
            results(i_condition).TMR = trial.TMR;
            
            results(i_condition).f0 = options.test.voices(trial.dir_voice).f0;
            results(i_condition).ser = options.test.voices(trial.dir_voice).ser;
            
            %Log timestamps to be able to calculate REACTION TIMES!!
            results(i_condition).trial_start_timestamp = trial.timestamp;
            results(i_condition).stim_start_timestamp = h.timestamp;
            results(i_condition).trial_dur = trial_dur;
        else
            results.words = repeatedWords;
            results.sentence = sentence;
            results.nwords_correct = length(repeatedWords);
            
            results.label = options.test.voices(trial.dir_voice).label;
            results.dir_voice = trial.dir_voice;
            results.vocoder = trial.vocoder;
            results.TMR = trial.TMR;
            
            results.f0 = options.test.voices(trial.dir_voice).f0;
            results.ser = options.test.voices(trial.dir_voice).ser;
            
            results.trial_start_timestamp = trial.timestamp;
            results.stim_start_timestamp = h.timestamp;
            results.trial_dur = trial_dur;
        end
        expe.test.conditions(i_condition).done = 1;
%         save(filename, 'expe', 'options', 'results');
        save([options.result_path  options.res_filename], 'expe', 'options', 'results');
        
        %save the audio recording:
        f0 = options.test.voices(trial.dir_voice).f0;
        ser = options.test.voices(trial.dir_voice).ser;
        TMR = trial.TMR;
%         fname = sprintf('Condition%s_Sentence%s_Voc%s_GPR%.2f_SER%.2f_TMR%d', num2str(i_condition) ,num2str(trial.test_sentence),...
%             num2str(trial.vocoder) , f0, ser, TMR);
        fname = sprintf('Condition%d_Sentence%d_Voc%d_GPR%.2f_SER%.2f_TMR%d', ...
            i_condition, trial.test_sentence, trial.vocoder, f0, ser, TMR);
% N:        fname = fullfile(options.res_foldername, [fname, '.flac']); %save as .flac for space purposes
        fname = fullfile(options.rec_foldername, [fname, '.flac']); %save as .flac for space purposes
        
        if ~exist(fname,'file')
% N:            audiowrite(fname,y,fs,'BitsPerSample',24);
            audiowrite(fname,y,fs,'BitsPerSample',16); % paolot 16 bits is probably enought too
            % check the settings of the audiorecorder below as well!
        end
            
   
        set(h.continue,'Value',1);
        uiresume(h.f);
    end

    function playSnd(stimulus, fs)
        
        h.timestamp = datestr(now);
        tic();
        
        %%%%%%%%%%%%%%%%%%%%%%%
%        RECORD TRIAL (STIMULUS + RESPONSE):
% n:        h.recObj = audiorecorder(44100,24,1,0);
% ridiculously high! Can't we just downsample to 22050 and 16 bits, it's
% only for rescoring/double checking the repetitions
%         h.recObj = audiorecorder(22050,16,1,0); 
        h.recObj = audiorecorder(22050,16,1); % Device Error: Invalid sample rate
        disp('Recording...')
        record(h.recObj);
       % play(h.recObj);
        %%%%%%%%%%%%%%%%%%%%%%
        
        set(h.Box.continue,'Enable','off');
        stimulus = audioplayer(stimulus,fs,16);
        playblocking(stimulus);
        pause(0.5);
        set(h.Box.continue,'Enable','on');
        set(h.Box.play,'Enable','off');
        uiresume(h.f);
        
        
    end

    

end

