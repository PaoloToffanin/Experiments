
<<<<<<< HEAD
%     participant.name = 'Hellooo';
    participant.name = 'paolo';
%     participant.age = 24;
    participant.age = 55;
    participant.sex = 'f';
    participant.language = 'English'; % English or Dutch
    participant.kidsOrAdults = 'Kid'; % we leave empty for kids because I am not sure whether we'd fuck up some file names/if statements
    if participant.age > 18
        participant.kidsOrAdults = 'Adult';
    end

    participant.sentencesCourpus = 'VU_zinnen';
%     participant.sentencesCourpus = 'plomp';
%     
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
=======

>>>>>>> d3d669344a93caabb3980f44cf5ae9bc169f3361


participant.name = 'test';
participant.age = 24;
participant.sex = 'm';
participant.language = 'English'; % English or Dutch
participant.kidsOrAdults = 'Kid';
if participant.age > 18
    participant.kidsOrAdults = 'Adult';
end

% % this is debi's computer
% [~, name] = system('hostname');
% 'DESKTOP-ETB98NQ' 

