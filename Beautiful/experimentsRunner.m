
%% Participant initialization - returns structures: participant & options
defineParticipantDetails

%% SANITY CHECKS INPUTS
participant = checkInputsSanity(participant, options);

%% experimenter GUI for tasks administrations
if ~isempty(participant)
    testRunner_GUI(participant)
end


