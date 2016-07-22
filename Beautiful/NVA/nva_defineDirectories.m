function options = nva_defineDirectories(options, participant)


    options.wordsFolder = [options.home '/sounds/NVA/individualWords/'];
    if ~exist(options.wordsFolder, 'dir')
        error(['Sounds folder ' options.wordsFolder ' does not exists']);
    end
    if isempty(dir([options.wordsFolder '*.wav']))
        error([options.wordsFolder ' does not contain sound files']);
    end
    
    options.responsesFolder = [options.home '/Results/NVA/'];
    if ~exist(options.responsesFolder, 'dir')
        error(['Results folder ' options.responsesFolder ' does not exists']);
    end
    
    options.recordingsFolder = [options.home '/Results/NVA/Recordings/' participant.name '/'];
    if ~exist(options.recordingsFolder, 'dir')
        mkdir(options.recordingsFolder);
    end
    
end