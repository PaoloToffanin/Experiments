
participant.name = 'EDLIx020';
participant.forBert = false;
participant.forBert = false;
if participant.forBert 
    participant.name = 'Bert-cons2'; 
end

participant.age = 21;
participant.sex = 'f';
participant.language = 'Dutch'; % or English

% participant tasks set is specified through the name of the directories holding the experiments
% NOTE: keep NVA first
participant.expDir = {'NVA', 'fishy', 'emotion', 'MCI', 'gender', 'sos'};
if participant.forBert 
    participant.expDir = {'fishy', 'emotion', 'gender', 'sos'};
end
% participant.expDir = {'MCI', 'sos'}; %
% participant.expDir = {'MCI'}; % 
% participant.expDir = {'NVA'}; % 
% participant.expDir = {'sos'}; % 
% participant.expDir = {'emotion'};% 
%participant.expDir = {'fishy'};% 
%participant.expDir = {'gender'};%
%% do not edit from here
participant.kidsOrAdults = 'Kid';
if participant.age > 18
    participant.kidsOrAdults = 'Adult';
end

participant.sentencesCourpus = 'VU_zinnen';
