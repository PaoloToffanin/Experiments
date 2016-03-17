function fishy_run

% note: with kids we want to split the experiment in two and so there
% should be training test training test rather than training training test
% test. 

rng('shuffle')
run('../defineParticipantDetails.m')


paths2Add = {'../lib/SpriteKit', ...
             '../lib/MatlabCommonTools/'}; 
for ipath = 1 : length(paths2Add)
    if ~exist(paths2Add{ipath}, 'dir')
        error([paths2Add{ipath} ' does not exists, check the ../']);
    else
        addpath(paths2Add{ipath});
    end
end
options.home = getHome;
options = fishy_options(options, participant);
options.Bert = 0;
phase = 'training';
if ~exist(options.res_filename, 'file')
    [expe, options] = fishy_build_conditions(options);
else
    tmp = load(options.res_filename); % options, expe, results
    % results = tmp.results; % this isn't passed as an argument
    % later
    options = tmp.options;
    expe = tmp.expe;
    % check which phase should be started with
    phases = fieldnames(expe);
    for iphase = 1 : length(phases)
        % note that it checkes for test first, then training, so if
        % training is not finished it rigthfully starts from the
        % training rather than testing phase.
        if any([expe.(phases{iphase}).conditions.done] == 0);
            phase = phases{iphase}; % which of the conditions will have to be done will be figured out later
        end
    end
end

% if it is a repetition make everything new
if sum([expe.training.conditions.done, expe.test.conditions.done]) >= 4
    [expe, options] = fishy_build_conditions(options);
    phase = 'training';
end

fishy_main(expe, options, phase);
% if 'training' has just been done let's do testing otherwise terminate
if strcmp(phase, 'training')
    fishy_main(expe, options, 'test');
end
% results2txt

%------------------------------------------
% Clean up the path
for ipath = 1 : length(paths2Add)
    rmpath(paths2Add{ipath});
end