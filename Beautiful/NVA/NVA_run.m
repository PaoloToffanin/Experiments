function NVA_run
% Performs the NVA task according to dbSPL framework (scores which phoneme
% subjects repeats rather the only a count of them - the count is what is
% usually done in the clinic). It can choose between the Adults or kids
% versions of the task. The default is to run the kids version. If one
% desires to run the Adults version is should specify so as such:
% 
%   NVA_task_dbSPL('participantsID') % runs the kids version 
% 
%   NVA_task_dbSPL('participantsID', 'Adults')  % runs the adult version
% 
%

    rng('shuffle')
    run('../defineParticipantDetails.m')
%  participant.name = 'pilot';

    options = nva_options;

    pathsToAdd = {'../lib/MatlabCommonTools/'};
    for iPath = 1 : length(pathsToAdd)
        addpath(pathsToAdd{iPath})
    end
    
    options.home = getHome;
    
    volume = SoundVolume(.32);

    options = nva_defineDirectories(options, participant);
    
    options.listsFile = ['nvaList' participant.kidsOrAdults '.txt'];
    
    options.nLists = 2;
    if options.noise
%         options.nLists = 2 * length(options.TMR);
% PT: there isn't enough lists to make 2 * length(options.TMR) 
        options.nLists = length(options.TMR);
    end
    
    stopNow = false;
    [nvaLists, stopNow] = nva_getListWords(options, stopNow);
    if ~ stopNow
        nva_interface(nvaLists, options, participant, pathsToAdd);
    end
    checkResults = false;
    if checkResults
        scoreNVA(participant.name)
    end
    
%     for iPath = 1 : length(pathsToAdd)
%         rmpath(pathsToAdd{iPath})
%     end

end



