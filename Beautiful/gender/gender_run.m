function gender_run

    rng('shuffle')
    run('../defineParticipantDetails.m')

    options.subject_name = participant.name;
    options.language = lower(participant.language);
    % options.stage = 'generation'; uncomment o generate sounds stimuli
    phase = 'test';
    options.stage = phase;
    options.Bert = false;
    options = gender_options(options);
    
    if ~exist(options.result_path, 'dir')
        mkdir(options.result_path);
    end
    
    res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
    options.res_filename = res_filename;
    
    addpath(options.straight_path);
    addpath(options.spriteKitPath);

    
    if strcmp(options.stage, 'generation')
        generateStimuli(options, phase);
    else    
        opt = 'OK';
        if ~exist(res_filename, 'file')
            if nargin > 1
                opt = char(questdlg(sprintf('The options.subject_name "%s" doesn''t exist. Create it?', options.subject_name),'CRM','OK','Cancel','OK'));
            end
            switch opt
                case 'OK',
                    [expe, options] = gender_buildingconditions(options);
                case 'Cancel'
                    return
            end
        else
            if nargin > 1
                opt = char(questdlg(sprintf('Found "%s". Use this file?', res_filename),'CRM','OK','Cancel','OK'));
                switch opt
                    case 'OK',
                        load(options.res_filename); % options, expe, results
                    case 'Cancel'
                        return
                end
            else
                load(options.res_filename); % options, expe, results
            end
            
        end
        gender_main(expe, options, phase);
    end % end if generate

    rmpath(options.straight_path);
    rmpath(options.spriteKitPath);    
end