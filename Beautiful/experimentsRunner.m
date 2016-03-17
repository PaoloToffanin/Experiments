% close all
options = struct; % initialization

%% Participant initialization - returns structures: participant & options
% [participant, options] = defineParticipantDetails(options);
defineParticipantDetails
%% SANITY CHECKS INPUTS

% input sanity double checks
button = questdlg(sprintf(['sub ID: ' participant.name '\n',...
    'age: %d \n',...
    'sex: ' participant.sex '\n',...
    participant.kidsOrAdults ' version of tasks\n',...
    'language: ' participant.language '\n', ...
    ], participant.age ),...
    'Are participants info correct?','yes','no','no');

if strcmp(button, 'no')
    disp('Please enter valid participant details')
    participant = []; % otherwise experiment will continue with wrong data
    return
end


addpath('lib/MatlabCommonTools/');
options.home = getHome;
options.Bert = false; % true to run experiments with Bert options
save([options.home '/Results/' participant.name '.mat'], '-struct', 'participant');
rmpath('lib/MatlabCommonTools/');

participant = checkInputsSanity(participant, options);

%% experimenter GUI for tasks administrations
if ~isempty(participant)
    testRunner_GUI(participant)
end


%cd ~/Experiments/Beautiful/