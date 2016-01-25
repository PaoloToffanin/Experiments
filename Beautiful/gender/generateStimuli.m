function generateStimuli(options, phase)
    
    % remove all the generated files:
    % sound files, wav files, response structure
    
    delete(options.res_filename);
    
    opt = char(questdlg('Delete previously processed sound files?','Remove old sound files','yes','no','no'));
    switch opt
        case 'yes',
            delete([options.sound_path '/*.mat']);
            delete([options.tmp_path '/*.wav']);
        case 'no'
            return
    end
            
    [expe, options] = gender_buildingconditions(options);

    while mean([expe.(phase).trials.done])~=1 % Keep going while there are some trials to do
        itrial = find([expe.(phase).trials.done]==0, 1);
        trial = expe.(phase).trials(itrial); 
        gender_make_stim(options, trial);
        expe.(phase).trials(itrial).done = 1;
    end
end



