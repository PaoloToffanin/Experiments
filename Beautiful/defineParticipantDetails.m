
participant.name = 'EDLIx4';
% participant.name = 'test';
participant.age = 25;
participant.sex = 'f';
participant.language = 'Dutch'; % or English
% participant tasks set is specified through the name of the directories holding the experiments
% NOTE: keep NVA first
% participant.expDir = {'NVA', 'fishy', 'emotion', 'MCI', 'gender', 'sos'}; % 
participant.expDir = {'MCI', 'sos'}; % 
% participant.expDir = {'NVA'}; % 
% participant.expDir = {'sos'}; % 



%% do not edit from here
participant.kidsOrAdults = 'Kid';
if participant.age > 18
    participant.kidsOrAdults = 'Adult';
end

participant.sentencesCourpus = 'VU_zinnen';
