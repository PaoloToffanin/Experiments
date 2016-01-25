participantDetails
%% note
% paol8: i've added a clear all on participantDetails, so that the
% participant structure is renewed every time, might have undesired
% side-effects.


%% SANITY CHECKS INPUTS
button = questdlg(sprintf(['sub ID: ' options.subject_name '\n',...
    'age: %d \n',...
    'sex: ' options.sex '\n',...
    options.kidsOrAdults ' version of tasks\n',...
    'language: ' options.language '\n', ...
    ], options.age ),...
    'Are participants info correct?','yes','no','no'); 

if strcmp(button, 'no')
    disp('Please specify proper options')
    return
end

%% initialization variables for EXPERIMENT RUNNER GUI
options.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
options.expDir = {'NVA', 'fishy', 'emotion', 'gender'};
if strcmp(options.kidsOrAdults, 'Kid')
    options.expName = [options.expName {'fishy_run.m', 'emotion_run.m'}];
    options.expDir = [options.expDir {'fishy', 'emotion'}];
end
options.expButton = options.expDir;
options.buttonEnabled(1:length(options.expButton)) = {'on'};
% check if the study was run before and skip those tasks
completedExps = [];
for iExp = 1 : length(unique(options.expName))
    file = dir([options.home '/Results/' upper(options.expDir{iExp}(1)) ...
        options.expDir{iExp}(2:end), '/*' ...
        options.subject_name '*.mat']);
    % if the file does not exists no need to check where we got with it
    if ~isempty(file)
        % check if all conditions have been performed, not only if the file
        % exists
        tmp = load([options.home '/Results/', ... 
            upper(options.expDir{iExp}(1)) options.expDir{iExp}(2:end), '/' ...
            file.name]);   
        switch options.expDir{iExp}
            case 'NVA'
                if length(fields(tmp.responses)) == 2
                    completedExps = [completedExps iExp];
                end
            case 'fishy'
                switch length(tmp.results.training.conditions) 
                    case 2
                        completedExps = [completedExps find(strcmp(options.expDir, options.expDir{iExp}))];
                    case 1 
                        completedExps = [completedExps iExp];
                end
            case 'emotion'
                switch length(fields(tmp.results.training))
                    case 2
                        completedExps = [completedExps find(strcmp(options.expDir, options.expDir{iExp}))];
                    case 1 
                        completedExps = [completedExps iExp];
                end
            case 'gender'
                if length([tmp.results.test.responses.trial]) == tmp.options.test.total_ntrials
                    completedExps = [completedExps iExp];
                end
        end
        
    end
    % should add check determining whether all the phases were completed
end
% remove experiments that have already be completed
options.expDir(completedExps) = [];
options.expName(completedExps) = [];
options.buttonEnabled(completedExps) = {'off'};

%% check if emotion and fishy have been run in both versions for the kids 
% Gender and fishy should have also two conditions in the response file. 
% For kids, these two conditions are run seperately, so we need to
% make sure that they were run, or otherwise run them next. 
if strcmp(options.kidsOrAdults, 'Kid') && length(completedExps) == length(options.expName)
    repeated = {'fishy', 'emotion'};
    for irep = 1 : length(repeated)
        file = dir([options.home '/Results/' upper(repeated{irep}(1)) ...
            repeated{irep}(2:end), '/*' ...
            options.subject_name '*.mat']);
        % loaded data need to be stored in a temporary variable otherwise
        % they will overwrite the options structure
        tmp = load([options.home '/Results/' upper(repeated{irep}(1)) ...
            repeated{irep}(2:end) '/' file.name]);
        results = tmp.results;
        clear tmp
        switch repeated{irep}
            case 'emotion'
                if length(fields(results.training)) < 2
                    options.expName = {'emotion_run.m'};
                    options.expDir = {'emotion'};
                end
            case 'fishy'
                if length(results.training.conditions) < 2
                    options.expName = {'fishy_run.m'};
                    options.expDir = {'fishy'};
                end
        end
    end
end

%% if the experimenter entered a name that already exists check whether:
% 1 - he is aware of it
% 2 - if he is aware of it whether s/he wants to repeat the experiment
% overwriting the data (or are the result structures just extended?)
if isempty(options.expName)
    button = questdlg(sprintf(['Run again ' options.subject_name '?']),...
    ['sub ID: ' options.subject_name ' already run'], 'yes','no','no'); 
    if strcmp(button, 'no')
        disp('Interupting because this subject has been run already')
        return
    else
        % reinitialize
        % IS THIS OVERWRITING THE FILE OR IS IT EXTENDING THE STRUCTURES?
        button = questdlg(sprintf(['You are overwriting ' options.subject_name '''s data']),...
            ['Overwrite ' options.subject_name ' data?'], 'OK','No, thanks','No, thanks');
        if strcmp(button, 'OK')
            options.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
            options.expDir = {'NVA', 'fishy', 'emotion', 'gender'};
            options.expButton = options.expDir;
            if strcmp(options.kidsOrAdults, 'Kid')
                options.expButton = [options.expButton {'fishy', 'emotion'}];
            end
            options.buttonEnabled(1:length(options.expButton)) = {'on'};
        else
            disp('Change participants name in participantDetails before restarting')
            return
        end
    end
end

%% randomize presentation order
rng('shuffle');
if strcmp(options.kidsOrAdults, 'Kid') && isempty(completedExps)
    options.expName = [options.expName {'fishy_run.m', 'emotion_run.m'}];
    options.expDir = [options.expDir {'fishy', 'emotion'}];
end
randomSequence = randperm(length(options.expName));
options.expName= options.expName(randomSequence);
options.expDir = options.expDir(randomSequence);    


if strcmp(options.kidsOrAdults, 'Kid')
    % check that there are no repetitions between gender and fishy
    % if gender is repeated take fishy and put it in between and the other
    % way around for fishy
    repeated = {'fishy', 'emotion'};
    check = true;
    while check
        for iExp = 1 : length(repeated)
            distances = find(strcmp(options.expDir, repeated(iExp)));
            check = false;
            if length(distances) < 2
                break
            end
            if (distances(2) - distances(1)) == 1
                randomSequence = randperm(length(options.expName));
                options.expName= options.expName(randomSequence);
                options.expDir = options.expDir(randomSequence);
                check = true;
            end
        end
    end
end

%% experimenter GUI for tasks administrations
% for iexp = 1 : length(options.expName)
%     cd(options.expDir{iexp});
%     run(options.expName{iexp});
%     cd ..
% end
testRunner(options)


