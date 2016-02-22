
% options.subject_name = 'Jacquelien';
% options.subject_name = 'paolo';
participant.name = 'test';
participant.age = 24;
participant.age = 8;
participant.sex = 'f';
participant.language = 'Dutch'; % English or Dutch
participant.kidsOrAdults = 'Kid'; % we leave empty for kids because I am not sure whether we'd fuck up some file names/if statements
if participant.age > 18
    participant.kidsOrAdults = 'Adult';
end


addpath('lib/MatlabCommonTools/');
options.home = getHome;
options.Bert = false; % true to run experiments with Bert options
rmpath('lib/MatlabCommonTools/');

