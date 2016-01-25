function testRunner(options)
%% features to add

% 2 - buttons of already completed tasks should be shown but not be
% cliccable

%% implementation
    %  Create and then hide the UI as it is being constructed.
    heigthGUI = 285;
    f = figure('Visible','off','Position',[360, 500, 450, heigthGUI]);
    
    htext = uicontrol('Style', 'text', 'String', ...
        sprintf('Testing %s', options.subject_name),...
        'Position', [25, heigthGUI/2 - 70/2, 70, 50]);
       
    % Construct the components.
    % divide available vertical space among available buttons 
    availableLocs = linspace(0, heigthGUI, length(options.expButton) + 2);
    availableLocs([1 end]) = [];
    for iexp = 1 : length(options.expButton)
        task(iexp).b = uicontrol('Style', 'pushbutton',...
            'String', options.expButton{iexp}, ...
            'Enable', options.buttonEnabled{iexp}, ...
            'Position', [220, availableLocs(iexp), 70, 25], ...
            'Callback',{@runTask_Callback});
%             'String', options.expDir{iexp}, ...
    end

    % align all components, except the axes, along their centers.
    align([task(1:length(options.expName)).b],'Center','None');         
    f.Visible = 'on';
    
    % Push button callbacks. Each callback plots current_data in the
    % specified plot type.
    
    function runTask_Callback(source, eventdata)
%         cd(options.expDir{iexp});
        cd(source.String);
%         run(options.expName{iexp});
        run([source.String '_run.m']);
        cd ..
    end

    
end