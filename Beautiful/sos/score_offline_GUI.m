function h = score_offline_GUI(expe,options)

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
    

    h.f = figure('Visible', 'off','Units','normalized', 'Position', scrsz, ...
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
    h.init_continue = @(s,i,trial) init_continue(s,i);
    h.init_playbutton = @(s,fs) init_playbutton(s,fs);   
    h.set_progress = @(t, i, n) set_progress(t, i, n);
    
    h.set_contFlag = @(x) set(h.continue,'Value',x);
    h.get_contFlag = @() get(h.continue,'Value');
    

    % Assign the GUI a name to appear in the window title.
    h.f.Name = 'Speech on Speech: Experimenter GUI';
    
    
    % Make the GUI visible.
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

    function init_continue(sentence,i_condition)
        
        set(h.Box.continue,'Callback',@(hObject,callbackdata) continueCallback(expe,options,sentence,i_condition));
        
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

    function continueCallback(expe,options,sentence,i_condition)
        
        
        filename = options.res_filename;
        load(filename);
        
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
        
         
        results(i_condition).words_offline = repeatedWords;
        results(i_condition).nwords_correct_offline = length(repeatedWords);
        
        save(filename,'expe','options','results');
        
        set(h.continue,'Value',1);
        uiresume(h.f);
    end

    function playSnd(stimulus, fs)
        
        set(h.Box.continue,'Enable','off');
        stimulus = audioplayer(stimulus,fs,16);
        playblocking(stimulus);
        pause(0.5);
        set(h.Box.continue,'Enable','on');
        uiresume(h.f);
        
        
    end


end