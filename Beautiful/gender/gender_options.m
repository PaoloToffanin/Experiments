function options = gender_options(options)

    pathsToAdd = {'../lib/MatlabCommonTools/'};
    if ~exist(pathsToAdd{:}, 'dir')
        error([pathsToAdd{:} ' does not exists, check the ../']);
    else
        addpath(pathsToAdd{:});
        options.home = getHome;
    end
    
%     volume = SoundVolume(.42);
    volume = SoundVolume(.36);

    
    [~, name] = system('hostname');
%     options.result_path   = [options.home '/results/Gender'];
    options.result_path   = [options.home '/Results/Gender'];
    if ~exist(options.result_path, 'dir')
        mkdir(options.result_path);
    end
    options.sound_path = [options.home '/sounds/NVA/Dutch_equalized'];
    if options.Bert
        options.tmp_path   = [options.home '/sounds/NVA/gender/processed/Bert'];
    else
        options.tmp_path   = [options.home '/sounds/NVA/gender/processed/Original/'];
    end
    
    options.straight_path = '../lib/STRAIGHTV40_006b';
    options.spriteKitPath = '../lib/SpriteKit';

    if strncmp(name, 'debian', 6) % PT's computer
        options.sound_path = [options.home '/ownCloud/NVA/Dutch_equalized'];
        if options.Bert
            options.tmp_path   = '/mnt/disk2/processedSounds/NVA/gender/Bert';
        else
            options.tmp_path   = '/mnt/disk2/processedSounds/NVA/gender/Original/';
        end
    end

    options.result_prefix = 'gen_';
    
    if isempty(dir(options.sound_path))
        error('options.sound_path cannot be empty');
    end

    if ~exist(options.tmp_path, 'dir')
        mkdir(options.tmp_path);
    end
    
    if isempty(dir(options.tmp_path)) && ~strcmp(options.stage, 'generation')
        opt = char(questdlg('Running experiment without preprocessing sounds?','CRM','yes','no','no'));
        switch opt
            case 'yes',
                warning('This will slow down your experiment substantially, press ctrl+c if unhappy')
            case 'no'
                warning('call gender_run(''gen'') to generate the stimuli before running the exp')
                return
        end
        
    end
    
    % The current status of the experiment, number of trial and phase, is
    % written in the log file. Ideally this file should be on the network so
    % that it can be checked remotely. If the file cannot be reached, the
    % program will just continue silently.
    options.log_file = fullfile('results', 'status.txt');
   
end
