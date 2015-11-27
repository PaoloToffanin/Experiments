function [results, expe, terminate, nturns] = determineIfExit(results, expe, steps, ...
    differences, phase, options, response_accuracy, n_attempt, i_condition, u)

    nturns = sum(diff(sign(steps(steps~=0)))~=0);
    
    terminate = false;
    % Have we reached an exit condition?
    if nturns >= options.(phase).terminate_on_nturns 

        fprintf('====> END OF RUN because enough turns\n');

        results.( phase ).conditions(i_condition).att(n_attempt).exit_reason = 'nturns';
        expe.( phase ).conditions(i_condition).done = 1;
        expe.( phase ).conditions(i_condition).attempts = expe.( phase ).conditions(i_condition).attempts + 1;

        i_nz = find(steps~=0);
%         i_d  = find(diff(sign(steps(i_nz)))~=0);
%         i_tp = i_nz(i_d)+1;
        i_tp = i_nz(diff(sign(steps(i_nz)))~=0)+1;
        i_tp = [i_tp, length(differences)];
        i_tp = i_tp(end-(options.(phase).threshold_on_last_n_trials-1):end);

        results.( phase ).conditions(i_condition).att(n_attempt).diff_i_tp = i_tp;
        thr = mean(differences(i_tp)); %exp(mean(log(differences(i_tp))));
        results.( phase ).conditions(i_condition).att(n_attempt).threshold = thr;
        sd = std(differences(i_tp));
        results.( phase ).conditions(i_condition).att(n_attempt).sd = sd;

        % u it's used here, but it's only printed to screen
        fprintf('Threshold: %f st (%f st GPR, %f st VTL) [%f st] \n', thr, thr*u(1), thr*u(2), sd);

        terminate = true;

    elseif length(response_accuracy) >= options.(phase).terminate_on_ntrials

        fprintf('====> END OF RUN because too many trials\n');

        results.( phase ).conditions(i_condition).att(n_attempt).exit_reason = 'ntrials';
        expe.( phase ).conditions(i_condition).attempts = expe.( phase ).conditions(i_condition).attempts + 1;

        % Should we retry again?
        if expe.( phase ).conditions(i_condition).attempts >= options.(phase).retry + 1
            fprintf('      (will not try again)\n');
            expe.( phase ).conditions(i_condition).done = 1;
        end

        results.( phase ).conditions(i_condition).att(n_attempt).diff_i_tp = [];
        results.( phase ).conditions(i_condition).att(n_attempt).threshold = NaN;
        results.( phase ).conditions(i_condition).att(n_attempt).sd = NaN;

        terminate = true;
    elseif length(response_accuracy) >= options.(phase).change_step_size_n_trials ...
            && sum(response_accuracy(end - (options.(phase).change_step_size_n_trials-1) : end) == 0) >= ...
            (options.(phase).change_step_size_n_trials / 4 * 3) % PT if at least half of the responses are wrong stop
            
        %    && all(response_accuracy(end - (options.(phase).change_step_size_n_trials-1) : end) == 0)
        % All last n trials are incorrect % PT 15 consequently wrong trials is very close to impossible 

        fprintf('====> END OF RUN because too many wrong answers\n');

        results.( phase ).conditions(i_condition).att(n_attempt).exit_reason = 'nwrong';
        expe.( phase ).conditions(i_condition).attempts = expe.( phase ).conditions(i_condition).attempts + 1;

        % Should we retry again?
        if expe.( phase ).conditions(i_condition).attempts >= options.(phase).retry + 1
            fprintf('      (will not try again)\n');
            expe.( phase ).conditions(i_condition).done = 1;
        end

        terminate = true;
    end
    
    results.( phase ).conditions(i_condition).att(n_attempt).differences = differences;
    results.( phase ).conditions(i_condition).att(n_attempt).steps = steps;

end