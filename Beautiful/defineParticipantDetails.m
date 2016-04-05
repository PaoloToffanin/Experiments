% function [participant, options] = defineParticipantDetails(options)
% todo list: needs to be implemented differently if we want to use
% guiParticipantDetails.m

    participant.name = 'testti';
%     participant.age = 24;
    participant.age = 9;
    participant.sex = 'f';
    participant.language = 'English'; % English or Dutch
    participant.kidsOrAdults = 'Kid'; % we leave empty for kids because I am not sure whether we'd fuck up some file names/if statements
    if participant.age > 18
        participant.kidsOrAdults = 'Adult';
    end

    % update participant's values
%     participant = guiParticipantDetails(participant);
    
%     % input sanity double checks
%     button = questdlg(sprintf(['sub ID: ' participant.name '\n',...
%         'age: %d \n',...
%         'sex: ' participant.sex '\n',...
%         participant.kidsOrAdults ' version of tasks\n',...
%         'language: ' participant.language '\n', ...
%         ], participant.age ),...
%         'Are participants info correct?','yes','no','no');
% 
%     if strcmp(button, 'no')
%         disp('Please enter valid participant details')
%         participant = []; % otherwise experiment will continue with wrong data
%         return
%     end
% 
%     
%     addpath('lib/MatlabCommonTools/');
%     options.home = getHome;
%     options.Bert = false; % true to run experiments with Bert options
% 	save([options.home '/Results/' participant.name '.mat'], '-struct', 'participant');
%     rmpath('lib/MatlabCommonTools/');

% end