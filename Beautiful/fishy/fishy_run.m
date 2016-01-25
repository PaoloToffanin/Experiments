function fishy_run
    
rng('shuffle')
run('../participantDetails.m')

options = fishy_options(options);

paths2Add = {'../lib/SpriteKit', '../lib/MatlabCommonTools/'}; 
for ipath = 1 : length(paths2Add)
    if ~exist(paths2Add{ipath}, 'dir')
        error([paths2Add{ipath} ' does not exists, check the ../']);
    else
        addpath(paths2Add{ipath});
    end
end

if ~exist(options.res_filename, 'file')
    opt = char(questdlg(sprintf('The subject "%s" doesn''t exist. Create it?', options.subject_name),'JVO','OK','Cancel','OK'));
    switch lower(opt)
        case 'ok',
            [expe, options] = fishy_build_conditions(options);
            phase = 'training';
        case 'cancel'
            return
        otherwise
            error('Unknown option: %s',opt)
    end
else
    opt = questdlg(sprintf('Found "%s". Use this file?', options.res_filename),'JVO','OK','Cancel','No','OK');
    switch opt 
        case 'OK'
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
            if ~exist('phase', 'var')
                % the subject has already completed all the phases,
                % therefore we infer we are doing an additional testing
                % phase, not training
                phase = 'test';
                [expe, options] = repeatOrStop(phase, options);
                if isempty(expe) && isempty(options)
                    return
                end
            end
        case 'Cancel'
            return
        case 'No'
            opt = questdlg(sprintf('The result file %s will be deleted!\n Are you sure?', options.res_filename),'Warning','Yes','No','No');
            switch opt 
                case 'Yes'
                    delete(options.res_filename)
                    [expe, options] = fishy_build_conditions(options);
                case 'No'
                    return
            end

    end
   
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