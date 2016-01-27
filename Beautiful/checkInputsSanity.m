function participant = checkInputsSanity(participant, options)

    button = questdlg(sprintf(['sub ID: ' participant.name '\n',...
        'age: %d \n',...
        'sex: ' participant.sex '\n',...
        participant.kidsOrAdults ' version of tasks\n',...
        'language: ' participant.language '\n', ...
        ], participant.age ),...
        'Are participants info correct?','yes','no','no');

    if strcmp(button, 'no')
        disp('Please enter valid participant details')
        return
    end

    %% initialization variables for EXPERIMENT RUNNER GUI
    participant.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
    participant.expDir = {'NVA', 'fishy', 'emotion', 'gender'};
    if strcmp(participant.kidsOrAdults, 'Kid')
        participant.expName = [participant.expName {'fishy_run.m', 'emotion_run.m'}];
        participant.expDir = [participant.expDir {'fishy', 'emotion'}];
    end
    participant.expButton = participant.expDir;
    participant.buttonEnabled(1:length(participant.expButton)) = {'on'};
    % check if the study was run before and skip those tasks
    completedExps = [];
    for iExp = 1 : length(unique(participant.expName))
        file = dir([options.home '/Results/' upper(participant.expDir{iExp}(1)) ...
            participant.expDir{iExp}(2:end), '/*' ...
            participant.name '*.mat']);
        % if the file does not exists no need to check where we got with it
        if ~isempty(file)
            % check if all conditions have been performed, not only if the file
            % exists
            tmp = load([options.home '/Results/', ...
                upper(participant.expDir{iExp}(1)) participant.expDir{iExp}(2:end), '/' ...
                file.name]);
            switch participant.expDir{iExp}
                case 'NVA'
                    if length(fields(tmp.responses)) == 2
                        completedExps = [completedExps iExp];
                    end
                case 'fishy'
                    % we care only of test, training they can do redo
                    switch length(tmp.results.test.conditions)
                        case 2
                            completedExps = [completedExps find(strcmp(participant.expDir, participant.expDir{iExp}))];
                        case 1
                            completedExps = [completedExps iExp];
                    end
                case 'emotion'
                    % we care only of test, training they can do redo
                    switch length(fields(tmp.results.test))
                        case 2
                            completedExps = [completedExps find(strcmp(participant.expDir, participant.expDir{iExp}))];
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
    participant.expDir(completedExps) = [];
    participant.expName(completedExps) = [];
    participant.buttonEnabled(completedExps) = {'off'};

% DO i need to do this twice?
%     %% check if emotion and fishy have been run in both versions for the kids
%     % Gender and fishy should have also two conditions in the response file.
%     % For kids, these two conditions are run seperately, so we need to
%     % make sure that they were run, or otherwise run them next.
%     if strcmp(participant.kidsOrAdults, 'Kid') && length(completedExps) == length(participant.expName)
%         repeated = {'fishy', 'emotion'};
%         for irep = 1 : length(repeated)
%             file = dir([options.home '/Results/' upper(repeated{irep}(1)) ...
%                 repeated{irep}(2:end), '/*' ...
%                 participant.name '*.mat']);
%             % loaded data need to be stored in a temporary variable otherwise
%             % they will overwrite the options structure
%             tmp = load([options.home '/Results/' upper(repeated{irep}(1)) ...
%                 repeated{irep}(2:end) '/' file.name]);
%             results = tmp.results;
%             clear tmp
%             switch repeated{irep}
%                 case 'emotion'
%                     if length(fields(results.test)) < 2
%                         participant.expName = {'emotion_run.m'};
%                         participant.expDir = {'emotion'};
%                     end
%                 case 'fishy'
%                     if length(results.test.conditions) < 2
%                         participant.expName = {'fishy_run.m'};
%                         participant.expDir = {'fishy'};
%                     end
%                 % note that we do not know which version was run, so that should be figure out sometime    
%             end
%         end
%     end

    %% if the experimenter entered a name that already exists check whether:
    % 1 - he is aware of it
    % 2 - if he is aware of it whether s/he wants to repeat the experiment
    % overwriting the data (or are the result structures just extended?)
    if isempty(participant.expName)
        button = questdlg(sprintf(['Run again ' participant.name '?']),...
            ['sub ID: ' participant.name ' already run'], 'yes','no','no');
        if strcmp(button, 'no')
            participant = [];
            disp('Interupting because this subject already perform the experiments')
            return
        else
            % reinitialize
            % IS THIS OVERWRITING THE FILE OR IS IT EXTENDING THE STRUCTURES?
            button = questdlg(sprintf(['You are overwriting ' participant.name '''s data']),...
                ['Overwrite ' participant.name ' data?'], 'OK','No, thanks','No, thanks');
            if strcmp(button, 'OK')
                participant.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
                participant.expDir = {'NVA', 'fishy', 'emotion', 'gender'};
                participant.expButton = participant.expDir;
                if strcmp(participant.kidsOrAdults, 'Kid')
                    participant.expButton = [participant.expButton {'fishy', 'emotion'}];
                end
                participant.buttonEnabled(1:length(participant.expButton)) = {'on'};
            else
                disp('Change participants name in participantDetails before restarting')
                return
            end
        end
    end

    %% randomize presentation order
    rng('shuffle');
    if strcmp(participant.kidsOrAdults, 'Kid') && isempty(completedExps)
        participant.expName = [participant.expName {'fishy_run.m', 'emotion_run.m'}];
        participant.expDir = [participant.expDir {'fishy', 'emotion'}];
    end
    randomSequence = randperm(length(participant.expName));
    participant.expName= participant.expName(randomSequence);
    participant.expDir = participant.expDir(randomSequence);


    if strcmp(participant.kidsOrAdults, 'Kid')
        % check that there are no repetitions between gender and fishy
        % if gender is repeated take fishy and put it in between and the other
        % way around for fishy
        repeated = {'fishy', 'emotion'};
        check = true;
        while check
            for iExp = 1 : length(repeated)
                distances = find(strcmp(participant.expDir, repeated(iExp)));
                check = false;
                if length(distances) < 2
                    break
                end
                if (distances(2) - distances(1)) == 1
                    randomSequence = randperm(length(participant.expName));
                    participant.expName= participant.expName(randomSequence);
                    participant.expDir = participant.expDir(randomSequence);
                    check = true;
                end
            end
        end
    end

end % end of the function