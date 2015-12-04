participantDetails

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

options.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
options.expDir = {'NVA', 'fishy', 'emotion', 'gender'};

% randomize = randperm(length(exp));

% exp = exp(randperm(length(exp))); % while we test we don't randomize the
% sequence, going through each experiment one by one might be easier

% check if the study was run before
completedExps = [];
for iExp = 1 : length(options.expName)
    file = dir([options.home '/Results/' upper(options.expDir{iExp}(1)) ...
        options.expDir{iExp}(2:end), '/*' ...
        options.subject_name '*.mat']);
    % if the file does not exists no need to check where we got with it
    if ~isempty(file)
        % check if all conditions have been performed?
        completedExps = [completedExps iExp];
        % remove the experiment from the set of experiments to run
    end
    % should add check determining whether all the phases were completed
end

% remove experiments
options.expDir(completedExps) = [];
options.expName(completedExps) = [];

%% check experimenter is fine with overwriting the name
if isempty(options.expName)
    button = questdlg(sprintf(['sub ID: ' options.subject_name ' already run\n']),...
    ['Run again ' options.subject_name '?'], 'yes','no','no'); 

    if strcmp(button, 'no')
        disp('Interupting because this subject has been run already')
        return
    else
        % reinitialize
        options.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
        options.expDir = {'NVA', 'fishy', 'emotion', 'gender'};
    end

end

    

randomSequence = randperm(length(options.expName));
options.expName= options.expName(randomSequence);
options.expDir = options.expDir(randomSequence);

for iexp = 1 : length(options.expName)
    cd(options.expDir{iexp});
    run(options.expName{iexp});
    cd ..
end



