function h = initSubjGUI(options)
         
    %iTrial = 1;
    
    h = struct();
    
    scrsz = get(0,'MonitorPositions');
    
    if size(scrsz,1) > 1
        scrsz = scrsz(1,:); %select the first row which should correspond to the subject's screen.
    end
    
    fntsze = 20;
    
    if ~is_test_machine
        left = scrsz(1); bottom = scrsz(2); width = scrsz(3); height = scrsz(4);
    else
        left = -1024; bottom=0; width=1024; height=768;
    end
    
    scrsz = [left, bottom, width, height];
    
    n_rows = 1; 
    n_cols = 3; 
    grid_sz = [n_cols, n_rows]*300;
    
    %Progress bar params
    h.main_text_color = [1 1 1]*.9;
    h.background_color = [.6 .6 .6];
    h.progress_bar_color = [.5 .8 .5];
    
    
    %  Create and then hide the UI as it is being constructed.
    h.f = figure('Visible', 'off', 'Position', scrsz, ...
        'Toolbar', 'none', 'Menubar', 'none', 'NumberTitle', 'off');
    
    h.instructions = uicontrol('Style', 'text', 'Units', 'pixel',...
        'Position', [width/2-grid_sz(1)/2, height/2-150, grid_sz(1), 200], ...
        'HorizontalAlignment', 'center', 'FontSize', fntsze);
    
    % Progress bar
    h.waitbar = axes('Units', 'pixel', 'Position', [width/2-300, height/2+150, 600, 25], 'Box', 'off', ...%height-50
        'XColor', 'w', 'YColor', 'w', 'XTick', [], 'YTick', []);
    h.waitbar_legend = uicontrol('Style', 'text', 'Units', 'pixel', 'Position', [width/2-300, height/2+200, 600, 50], ...%height-101
        'HorizontalAlignment', 'center', 'FontSize', fntsze, 'ForegroundColor', h.main_text_color, 'BackgroundColor', h.background_color);
    
     % Assign the a name to appear in the window title.
    h.f.Name = 'Spraak in achtergrondgeluid';
    
    h.hstart = uicontrol('Style','pushbutton',...
        'String','BEGIN','Units', 'pixel',...
        'Position', [width/2-grid_sz(1)/2, height/2-grid_sz(2), grid_sz(1), 100],...
        'HorizontalAlignment', 'center','FontSize', fntsze-5,'Callback','uiresume');%[width/2-grid_sz(1)/2, height/2-grid_sz(2)/2, grid_sz(1), 100]
    
    
    %-------ACTIONS:
    
    h.hide_instruction = @() set(h.instructions, 'Visible', 'off');
    h.show_instruction = @() set(h.instructions, 'Visible', 'on');
    h.set_instruction = @(t) set_instruction(h,t);
    
    h.set_hstart_text = @(t) set(h.hstart, 'String', t);
    h.hide_start = @() set(h.hstart, 'Visible', 'off');
    h.show_start = @() set(h.hstart, 'Visible', 'on');
    h.set_hstart_callback = @(t) set(h.hstart, 'CallBack',t);
    h.make_visible = @() set(h.f, 'Visible', 'on');
    h.set_progress = @(t, i, n) set_progress(h, t, i, n);
    
    h.disable_start = @() set(h.hstart,'Enable','off');
    h.enable_start = @() set(h.hstart,'Enable','on');
   
    
    
    function set_instruction(h,t)
        
        instr = textwrap(h.instructions, {t}); 
        set(h.instructions, 'String', instr);
        
    end
    
    function set_progress(h, t, i, n)

        if n>0
            set(h.waitbar_legend, 'String', sprintf('%s: %d/%d', t, i, n));
            fill([0 1 1 0] * i/n, [0 0 1 1], h.progress_bar_color, 'Parent', h.waitbar, 'EdgeColor', 'none');
        else
            set(h.waitbar_legend, 'String', t);
            fill([0 1 1 0] * 0, [0 0 1 1], h.progress_bar_color, 'Parent', h.waitbar, 'EdgeColor', 'none');
        end
        set(h.waitbar, 'XColor', 'w', 'YColor', 'w', 'XTick', [], 'YTick', [], 'Xlim', [0 1], 'YLim', [0 1]);



    end

end