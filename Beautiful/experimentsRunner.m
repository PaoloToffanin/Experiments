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

exp = struct('dir', {'emotion', 'fishy', 'gender'}, ... 
    'name', {'emotion_run.m', 'fishy_run.m', 'gender_run.m'});

% exp = struct('dir', {'NVA'}, ... 
%     'name', {'NVA_run.m'});


% randomize = randperm(length(exp));

% exp = exp(randperm(length(exp))); % while we test we don't randomize the
% sequence, going through each experiment one by one might be easier

for iexp = 1 : length(exp)
    cd(exp(iexp).dir);
    run(exp(iexp).name);
    cd ..
end



