function participant = checkInputsSanity(participant, options)


    %% initialization variables for EXPERIMENT RUNNER GUI
    % english version of the task does not do NVA
    if strcmp(participant.language , 'English')
        participant.expDir(strcmp(participant.expDir, 'NVA')) = [];
    end
    % kids versions of fishy and emotion is split in half
    if strcmp(participant.kidsOrAdults, 'Kid')
        participant.expDir = [participant.expDir {'fishy', 'emotion'}];
    end
    participant.expButton = participant.expDir;
    participant.buttonEnabled(1:length(participant.expDir)) = {'off'};
    % check if the study was run before and skip those tasks
    completedExps = [];
%     for iExp = 1 : length(unique(participant.expName))
    for iExp = 1 : length(unique(participant.expDir))
%         file = dir([options.home '/Results/' upper(participant.expDir{iExp}(1)) ...
%             participant.expDir{iExp}(2:end), '/*' ...
%             participant.name '*.mat']);
        file = dir([options.home '/Results/' upper(participant.expDir{iExp}(1)) ...
            participant.expDir{iExp}(2:end), '/*' ...
            participant.name '.mat']);
        % if the file does not exists no need to check where we got with it
        if ~isempty(file)
            % check if all conditions have been performed, not only if the file
            % exists
            % this if statement is to accomodate the data structure of the MCI task
            if length(file) > 1 
                % we only care of test, training they can do again
                file = file(cellfun('isempty', strfind({file.name}, 'training')));
            end
%            tmp = load([file.folder '/' file.name]);
            % this is to fix the test run
%             if length(file) > 1
%                 fprintf('%i response files found\n', length(file)); 
%                 file(cellfun('isempty', strfind({file.name}, 'test.mat'))) = [];
%             end
            tmp = load([options.home '/Results/', ...
                upper(participant.expDir{iExp}(1)) participant.expDir{iExp}(2:end), '/' ...
                file.name]);

            switch participant.expDir{iExp}
                case 'NVA'
%                    if length(fields(tmp.responses)) >= 2
                    navLists = fieldnames(tmp.responses);
                    navLists(cellfun('isempty', strfind(navLists, 'list_'))) = [];
                    nLists = length(navLists);
                    countFinished = 0;
                    for list = 1 : nLists
                        % find last attempt:
                        nAttempt = length(tmp.responses.(navLists{list}));
                        if length(tmp.responses.(navLists{list})(nAttempt).word) == 12
% 12 is the number of word tested per list
%                                length(tmp.responses.(navLists{list}).timeFromStart)
                            countFinished = countFinished + 1;
                        end
                    end
                    if countFinished == nLists;
                        completedExps = [completedExps iExp];
                    end
                case 'fishy'
                    % we care only of test, training they can do redo
                    if isfield(tmp,'results')
                        if isfield(tmp.results, 'test')
                            switch length(tmp.results.test.conditions)
                                case 2
                                    completedExps = [completedExps ...
                                        find(strcmp(participant.expDir, participant.expDir{iExp}))];
                                case 1
                                    completedExps = [completedExps iExp];
                            end
                        end
                    end
                case 'emotion'
                    % we care only of test, training they can redo
                    if isfield(tmp.results, 'test')
                        switch length(fields(tmp.results.test))
                            case 2
                                completedExps = [completedExps  ...
                                    find(strcmp(participant.expDir, participant.expDir{iExp}))];
                            case 1
                                completedExps = [completedExps iExp];
                        end
                    end
                case 'gender'
                    if (isfield(tmp, 'results') && ...
                            length([tmp.results.test.responses.trial]) == tmp.options.test.total_ntrials)
                        completedExps = [completedExps iExp];
                    end
                case 'MCI'
                    % we care only of test, training they can redo
                    if sum([tmp.stimuli.done] == 1) == length(tmp.stimuli)
                        completedExps = [completedExps iExp];
                    end
                case 'sos'
                    % we care only of test, training they can redo
                    if (isfield(tmp, 'results') && ...
                            length([tmp.expe.test.conditions.done]) == sum([tmp.expe.test.conditions.done]))
                        completedExps = [completedExps iExp];
                    end
                otherwise
                    error('\nThe task %s does not exists\nTyping error??\n', participant.expDir{iExp});
            end

        end
        % should add check determining whether all the phases were completed
    end
    % remove experiments that have already be completed
    participant.expDir(completedExps) = [];
%     participant.expName(completedExps) = [];
%     participant.buttonEnabled(completedExps) = {'off'};

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
%     if isempty(participant.expName)
    if isempty(participant.expDir)
        button = questdlg(sprintf(['Run again ' participant.name '?']),...
            ['sub ID: ' participant.name ' already run'], 'yes','no','no');
        if strcmp(button, 'no')
            participant = [];
            disp('Interupting because this subject already perform the experiments')
            return
        else
            % reinitialize
            % IS THIS OVERWRITING THE FILE OR IS IT EXTENDING THE STRUCTURES?
            button = questdlg(sprintf(['You are extending ' participant.name '''s data']),...
                ['Overwrite ' participant.name ' data?'], 'OK','No, thanks','No, thanks');
            if strcmp(button, 'OK')
%                 participant.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
                participant.expDir = {'NVA', 'fishy', 'emotion', 'gender'};
%                 participant.expButton = participant.expDir;
                if strcmp(participant.kidsOrAdults, 'Kid')
                    participant.expDir = [participant.expDir {'fishy', 'emotion'}];
                end
%                 participant.buttonEnabled(1:length(participant.expDir)) = {'on'};
            else
                disp('Change participants name in participantDetails before restarting')
                return
            end
        end
    end

    %% randomize presentation order
    rng('shuffle');
    if any(strcmp(participant.expDir, 'NVA'))
        randomSequence = randperm(length(participant.expDir) - 1) + 1;
        addNVA = true;
    else
        randomSequence = randperm(length(participant.expDir));
        addNVA = false;
    end% NVA is
%     always first, but if it has already been performed it should not be in there 
%     randomSequence = randperm(length(participant.expName));
%     participant.expName= participant.expName(randomSequence);
    participant.expDir = participant.expDir(randomSequence);
    % NVA 
    
   
    % for the adults there are no repetitions, so it is not important
    if strcmp(participant.kidsOrAdults, 'Kid') && length(participant.expDir) > 2
        % check that there are no repetitions between gender and fishy
        % if gender is repeated take fishy and put it in between and the other
        % way around for fishy
        repeated = {'fishy', 'emotion'}; 
%         participant.expDir(end + 1 : end + 2) = repeated(:);
        stopSearch = false;
        while true
            for iExp = 1 : length(repeated)
                uans = find(strcmp(repeated{iExp}, participant.expDir));
                if length(uans) > 1 && (uans(2) - uans(1)) < 2
                    stopSearch = false;
                    participant.expDir = participant.expDir(randperm(length(participant.expDir)));
                    break
                end
                if length(uans) > 1 && (uans(2) - uans(1)) >= 2
                    stopSearch = true;
                end
                if length(uans) == 1
                    stopSearch = true;
                end
            end % for iExp = 1 : length(repeated)
            if stopSearch
                break
            end
        end % while true
    end % if strcmp(participant.kidsOrAdults, 'Kid')
    if addNVA
        participant.expDir = {'NVA', participant.expDir{:}};
    end
 %REMOVE LATER IS JUST FOR TESTING   
%      participant.expDir = {'gender'};
    
 % set the order of the buttons name to be identical to expDir, enabled
    % them too
%     participant.expButton = participant.expButton(randomSequence);
end % end of the function