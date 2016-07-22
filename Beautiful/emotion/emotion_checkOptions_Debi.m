function [attempt, expe, options, results, cue] = emotion_checkOptions_Debi(options, phase, cue)
% Function checking whether the phases should be repeated, or
% simply added to the results structure (initializes results to empty if 
% first run)
% for DEBI only the normalized cue are run, so we get rid of intact!

    attempt = 1; % attempt is 1 by default, will be updated only if the 
    % experimenter specifies so
    if exist(options.res_filename, 'file')
        load(options.res_filename);
        % check if the structure should be extended
        if exist('results', 'var')
            previousPhases = fieldnames(results);
            % if training has already been done do testing, if they have
            % both been already done than add an attempt
            % phase is not given as an output argument so I do not think we
            % need this bit skipping the training phase. 
%             if any(strcmp(previousPhases, 'training'))
%                 phase = test;
%             end
            if any(strcmp(previousPhases, 'test'))
                nAttempts = length(results.(previousPhases{strcmp(previousPhases, 'test')}).(cue).att);
                attempt = nAttempts + 1;
            end
        else
            [expe, options] = building_conditions(options);
            results = struct; % initialized as empty so that the function has equal nargout
        end % if exists results
    else
        [expe, options] = building_conditions(options);
        results = struct; % initialized as empty so that the function has equal nargout
    end
end