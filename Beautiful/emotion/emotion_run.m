function emotion_run%(subject) 
    
%     subName = 'simulate';
    run('../participantDetails.m') 
    % this load options with subject's details
    % we should have a script that checks which cue have been run for which
    % age and than make a choice based on that information, so that we have
    % the same type of cues equally spread accross ages (and also sexes? - this
    % information should therefore be included in some matlab file?)
    cue = {'normalized', 'intact'};
    cue = cue(randperm(length(cue)));
    
    if strcmp(options.subject_name, 'test')
%         for attempts = 1 : 1
            cue = cue(randperm(length(cue)));
            for icue = 1 : length(cue);
                phase = {'training', 'test'};
                for iphase = 1 : length(phase)
                    fprintf('I am running %s %s %s\n', options.subject_name, phase{iphase}, cue{icue})
                    emotion_main(options.subject_name, phase{iphase}, cue{icue});
                end
            end
%         end
    else
        for icue = 1 : length(cue);
            phase = {'training', 'test'};
            for iphase = 1 : length(phase)
                fprintf('I am running %s %s %s\n', options.subject_name, phase{iphase}, cue{icue})
                emotion_main(options.subject_name, phase{iphase}, cue{icue});
            end
        end
    end
end

% load /home/paolot/results/Emotion/emo_name.mat

%       run('../participantDetails.m')
%       emotion_main(options.subject_name, 'training', 'intact');
%       emotion_main(options.subject_name, 'training', 'normalized');
%       emotion_main(options.subject_name, 'test', 'intact');
%       emotion_main(options.subject_name, 'test', 'normalized');
