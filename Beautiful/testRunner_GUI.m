function testRunner_GUI(participant)
%% features to add
% make it impossible for participants to run tasks without following the
% order of presentation that the experimenter chooses.
% 1 - shading of buttons resambling the order of the task to choose (enable 
% disable buttons?) OR:
% 2 - substituting taskname with task1, task2, so that participants can be
% independent but are not choosing a random order themselves

    %% note paol8 added a clear all on participantDetails, so that the
    % participant structure is renewed every time, might have undesired
    % side-effects.
%% implementation
    %  Create and then hide the UI as it is being constructed.
    heigthGUI = 285;
    f = figure('Visible','off',...
        'MenuBar','None', ...
        'ToolBar', 'none', ...
        'NumberTitle', 'off', ...
        'Position',[100, 200, 450, heigthGUI], ...
        'Name', 'testRunner');
    
    uicontrol('Style', 'text', 'String', ...
        sprintf('Testing %s', participant.name),...
        'Position', [25, heigthGUI/2 - 70/2, 70, 50]);
       
    % Construct the components.
    % divide available vertical space among available buttons 
%     availableLocs = linspace(0, heigthGUI, length(participant.expButton) + 2);
%     availableLocs([1 end]) = [];
%     for iexp = 1 : length(participant.expButton)
%         task(iexp).b = uicontrol('Style', 'pushbutton',...
%             'String', participant.expButton{iexp}, ...
%             'Enable', participant.buttonEnabled{iexp}, ... 
%             'Position', [220, availableLocs(length(participant.expButton) + 1 - iexp), 70, 25], ... // starts drawing from the button
%             'Callback',{@runTask_Callback});
%     end
    % expDir does not consider that kids repeat fishy and emotion
    availableLocs = linspace(0, heigthGUI, length(participant.expDir) + 2);
    availableLocs([1 end]) = [];
    for iexp = 1 : length(participant.expDir)
        task(iexp).b = uicontrol('Style', 'pushbutton',...
            'String', participant.expDir{iexp}, ...
            'Enable', participant.buttonEnabled{iexp}, ...
            'Position', [220, availableLocs(length(participant.expDir) + 1 - iexp), 70, 25], ... // starts drawing from the button
            'Callback',{@runTask_Callback});
    end

    % align all components, except the axes, along their centers.
%     align([task(1:length(participant.expName)).b],'Center','None');         
%     align([task(1:length(participant.expButton)).b], 'Center', 'None'); 
    align([task(1:length(participant.expDir)).b], 'Center', 'None'); 
    countTasks = 1;
    % if some tasks have already been completed
%     if length(participant.expDir) < length(participant.expButton)
%         countTasks = length(participant.expButton) + 1 - length(participant.expDir);
%     end
    
    
    task(countTasks).b.Enable = 'on';
    f.Visible = 'on';
    
    % This Push button callbacks runs the specified experiment
%     function runTask_Callback(source, eventdata)
    function runTask_Callback(source, ~)
        task(countTasks).b.Enable = 'off';
        cd(source.String);
        source.Enable = 'off';
        run([source.String '_run.m']);
        cd ..
        countTasks = countTasks + 1;
        task(countTasks).b.Enable = 'on';
    end

    
end