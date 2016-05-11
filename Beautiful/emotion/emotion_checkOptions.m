function [attempt, expe, options, results, cue] = emotion_checkOptions(options, phase, cue)
% Function checking whether the phases and cues should be repeated, or
% simply added to the results structure (initializes results to empty if 
% first run)

    attempt = 1; % attempt is 1 by default, will be updated only if the 
    % experimenter specifies so
    if exist(options.res_filename, 'file')
        load(options.res_filename);
        % check if the structure should be extended
        if exist('results', 'var')
            previousPhases = fieldnames(results);
            % if the previous phases were completed then extend them,
            % otherwise leave as is. 
            % Attempt is 1 by default, will be updated otherwise
            if any(strcmp(previousPhases, phase))
                % check whether the cue condition was already completed
                indexPhase = strcmp(previousPhases, phase);
                previousCues = fieldnames(results.(previousPhases{indexPhase}));
                if any(strcmp(previousCues, cue))
                    indexCue = strcmp(previousCues, cue);
                    % check whether the last attempt was completed 
                    % successfully (e.g. all trials were completed) ;
                    nAttempts = length(results.(previousPhases{indexPhase}).(previousCues{indexCue}).att);
                    if length(results.(previousPhases{indexPhase}).(previousCues{indexCue}).att(nAttempts).responses) ...
                            == length(expe.(previousPhases{indexPhase}).condition)
                        % check:
                        % A: switch to the other cue if not completed 
                        if length(fieldnames(results.(previousPhases{indexPhase}))) == 1
                            cue = {'normalized', 'intact'}; % overwrite cue to assign the other cue
                            cue(~strcmp(cue, cue{indexCue})) = [];
                            cue = cue{:}; % to be assigned to the structure it has to be character!
%                             options = emotion_getCue(cue, options);
                            [expe, options] = building_conditions(options);
                            % results remains the same, should be updated
                            % during the task
                        else
                            % we now just add another attempt
                        % B: ask whether a new attempt should be added 
%                             choice = questdlg(sprintf([[options.subject_name ' already completed ' phase ' ' cue '\n'], ...
%                                 'Would you like to repeat it?']), ...
%                                 'Previous phase or cue confound', ...
%                                 'yes','no','no');
%                             % Handle response
%                             switch choice
%                                 case 'yes'
%                                     disp('New attempt coming right up.')
                       % make a new attempt             
                                    attempt = nAttempts + 1;
%                                 case 'no'
%                                     disp('Experiments terminated.')
%                                     % make all the output empty so that we can use
%                                     % it to stop the function execution in main
%                                     attempt = [];
%                                     expe = [];
%                                     options = [];
%                                     results = [];
%                                     return
%                             end
                        end
                    else
                        % update attempts
                        attempt = nAttempts + 1;
                    end %update attempts numbers
                end
            end % if strfind
        else
            [expe, options] = building_conditions(options);
            results = struct; % initialized as empty so that the function has equal nargout
        end % if exists results
    else
        [expe, options] = building_conditions(options);
        results = struct; % initialized as empty so that the function has equal nargout
    end
end