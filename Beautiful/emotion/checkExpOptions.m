function [attempt, expe, options, results] = checkExpOptions(options, phase, cue)
% Function checking whether the phases and cues should be repeated, or
% simply added to the results structure (initializes results to empty if 
% first run)

    attempt = 1; % attempt is 1 by default, will be updated only if the 
    % experimenter specifies so
    if exist(options.res_filename, 'file')
        load(options.res_filename);
        % check if the structure should be extended
        previousPhases = fieldnames(results);
        % check if the previous phases were completed and then extend them,
        % otherwise leave as is, attempt is 1 by default, will be updated
        % otherwise
        if any(~ cellfun('isempty', strfind(previousPhases, phase)))
            % check whether the cue condition was already completed
            indexPhase = ~ cellfun('isempty', strfind(previousPhases, phase));
            previousCues = fieldnames(results.(previousPhases{indexPhase}));
            if any(~ cellfun('isempty', strfind(previousCues, cue)))
                indexCue = ~ cellfun('isempty', strfind(previousCues, cue));
                % check whether the attempt was completed successfully
                % (e.g. all trials were completed) ;
                nAttempts = length(results.(previousPhases{indexPhase}).(previousCues{indexCue}).att);
                % NOTE we check only the most recent attempt
                if length(results.(previousPhases{indexPhase}).(previousCues{indexCue}).att(nAttempts).responses) ...
                        == length(expe.(previousPhases{indexPhase}).condition)
                    % ask the experimenter whether a new attempt should be
                    % added or not
                    choice = questdlg(sprintf([[options.subject_name ' already completed ' phase ' ' cue '\n'], ...
                        'Would you like to repeat it?']), ...
                        'Previous phase or cue confound', ...
                        'yes','no','no');
                    % Handle response
                    switch choice
                        case 'yes'
                            disp('New attempt coming right up.')
                            attempt = nAttempts + 1;
                        case 'no'
                            disp('Experiments terminated.')
                            % make all the output empty so that we can use
                            % it to stop the function execution in main
                            attempt = [];
                            expe = [];
                            options = [];
                            results = [];
                            return 
                    end
                else
                    % update attempts
                    attempt = nAttempts + 1;
                end
                
            end
            
        end
    else
        [expe, options] = building_conditions(options);
        results = struct; % initialized as empty so that the function has equal nargout
    end
end