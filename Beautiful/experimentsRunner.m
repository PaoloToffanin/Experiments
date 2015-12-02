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


% exp = struct('dir', {'NVA', 'emotion', 'fishy', 'gender'}, ... 
%     'name', {'NVA_run.m', 'emotion_run.m', 'fishy_run.m', 'gender_run.m'});
% exp = struct('dir', {'fishy','emotion', 'gender'}, ... 
%     'name', {'fishy_run.m', 'emotion_run.m', 'gender_run.m'});


options.expName= {'NVA_run.m', 'fishy_run.m', 'emotion_run.m', 'gender_run.m'};
options.expDir = {'NVA', 'fishy', 'emotion', 'gender'};

% randomize = randperm(length(exp));

% exp = exp(randperm(length(exp))); % while we test we don't randomize the
% sequence, going through each experiment one by one might be easier

randomSequence = randperm(length(options.expName));
options.expName= options.expName(randomSequence);
options.expDir = options.expDir(randomSequence);

for iexp = 1 : length(options.expName)
    cd(options.expDir{iexp});
    run(options.expName{iexp});
    cd ..
end



