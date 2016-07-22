function emotion_run

    rng('shuffle')
    run('../defineParticipantDetails.m')
    % this load options with subject's details
    % we should have a script that checks which cue have been run for which
    % age and than make a choice based on that information, so that we have
    % the same type of cues equally spread accross ages (and also sexes? - this
    % information should therefore be included in some matlab file?)
%     cue = {'normalized', 'intact'};
%     cue = cue(randperm(length(cue)));
    cue = {'normalized'};
    phase = {'training', 'test'};
    % should we check whether this cue or phase have already been run?
    % input is checked with emotion_checkOptions, which is called in line:
    % 45 of emotion_main
    
    if strcmp(participant.name, 'test')
        for icue = 1 : length(cue)
            for iphase = 1 : length(phase)
                fprintf('I am running %s %s %s\n', participant.name, phase{iphase}, cue{icue})
                emotion_main(participant.name, phase{iphase}, cue{icue});
            end
        end
    else
        switch participant.kidsOrAdults
            case 'Adult'
                for icue = 1 : length(cue)
                    for iphase = 1 : length(phase)
                        fprintf('I am running %s %s %s\n', participant.name, phase{iphase}, cue{icue})
                        emotion_main(participant.name, phase{iphase}, cue{icue});
                    end
                end
            case 'Kid'
                for iphase = 1 : length(phase)
                    fprintf('I am running %s %s %s\n', participant.name, phase{iphase}, cue{1})
                    emotion_main(participant.name, phase{iphase}, cue{1});
                end
            otherwise
                fprintf('I do not recognize the option %s for participant.kidsOrAdults', participant.kidsOrAdults)
                return
        end
    end
    
    
end % end of the function emotion_run