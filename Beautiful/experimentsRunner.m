% close all

% options = struct; % initialization

%% Participant initialization - returns structures: participant & options
% [participant, options] = defineParticipantDetails(options);
defineParticipantDetails
%% SANITY CHECKS INPUTS
bertOptions = 'no';
if participant.forBert
    bertOptions = 'yes';
end
% input sanity double checks
button = questdlg(sprintf(['sub ID: ' participant.name '\n',...
    'age: %d \n',...
    'Bert version: %s \n',...
    'sex: ' participant.sex '\n',...
    participant.kidsOrAdults ' version of tasks\n',...
    'language: ' participant.language '\n', ...
    ], participant.age , bertOptions),...
    'Are participants info correct?','yes','no','no');

if strcmp(button, 'no')
    disp('Please enter valid participant details')
    participant = []; % otherwise experiment will continue with wrong data
    return
end


addpath('lib/MatlabCommonTools/');
options.home = getHome;
options.Bert = false; % true to run experiments with Bert options
if participant.forBert 
    options.Bert = true; % true to run experiments with Bert options
end
save([options.home '/Results/' participant.name '.mat'], '-struct', 'participant');
rmpath('lib/MatlabCommonTools/');

participant = checkInputsSanity(participant, options);

%% experimenter GUI for tasks administrations
if ~isempty(participant)
    testRunner_GUI(participant)
end


%cd ~/Experiments/Beautiful/