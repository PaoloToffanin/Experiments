function testRunner_GUI(participant)
%% features to add
% can't think at any at the moment

    %% note paol8 added a clear all on participantDetails, so that the
    % participant structure is renewed every time, might have undesired
    % side-effects.
%% implementation
    %  Create and then hide the UI as it is being constructed.
    heigthGUI = 285;
    f = figure('Visible','off','Position',[360, 500, 450, heigthGUI]);
    
    htext = uicontrol('Style', 'text', 'String', ...
        sprintf('Testing %s', participant.name),...
        'Position', [25, heigthGUI/2 - 70/2, 70, 50]);
       
    % Construct the components.
    % divide available vertical space among available buttons 
    availableLocs = linspace(0, heigthGUI, length(participant.expButton) + 2);
    availableLocs([1 end]) = [];
    for iexp = 1 : length(participant.expButton)
        task(iexp).b = uicontrol('Style', 'pushbutton',...
            'String', participant.expButton{iexp}, ...
            'Enable', participant.buttonEnabled{iexp}, ...
            'Position', [220, availableLocs(iexp), 70, 25], ...
            'Callback',{@runTask_Callback});
    end

    % align all components, except the axes, along their centers.
    align([task(1:length(participant.expName)).b],'Center','None');         
    f.Visible = 'on';
    
    % This Push button callbacks runs the specified experiment
    function runTask_Callback(source, eventdata)
        cd(source.String);
        run([source.String '_run.m']);
        cd ..
    end

    
end