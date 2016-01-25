function gender_run(varargin)
%   function expe_run(varargin)
%   can be run as:
%   1) gender_run % then it will run in automatic player with defaults:
%       expe_run('tryout', 'testing', 'english')
%
%   2) gender_run('english') % than it will only create the stimuli
%
%   3) gender_run(options.subject_name, phase) 
%   phase can be: 'training', 'test'
%   gender_run('tryout', 'test', 'english')
%   gender_run

    options.subject_name = 'test';
    phase = 'test';
    options.language = 'dutch';
%     options.language = 'english';
    options.stage = phase;
    switch nargin 
        case 1
            options.subject_name = 'tryout';
            options.stage = 'generation';
        case 3
            options.subject_name = varargin{1};
            phase = varargin{2};
            options.language = varargin{3};
    end
    
    options.Bert = true;
    
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