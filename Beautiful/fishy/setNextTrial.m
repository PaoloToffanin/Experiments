function [difference, differences, decision_vector, step_size, steps, swimming] = ... 
    setNextTrial(options, difference, differences, decision_vector, step_size, steps, phase)

    % decision vector contains the response accuracy of the current
    % participant

    if length(decision_vector) >= options.(phase).down_up(1) && ...
            all(decision_vector(end-(options.(phase).down_up(2)-1) : end) == 1)
        % shouldn't this second line be with a down_up(1) instead of 2?
        
        % The last n_down responses were correct -> Reduce
        % difference by step_size, then update step_size
        fprintf('--> DOWN by %f st\n', step_size);

        difference = difference - step_size;
        steps = [steps, -step_size];
        differences = [differences, difference];

        % Reset decision vector
        decision_vector = [];

        swimming = true;
        
    elseif length(decision_vector) >= options.(phase).down_up(2) && ...
            all(decision_vector(end-(options.(phase).down_up(2)-1) : end)==0)
        % The last n_up responses were incorrect -> Increase
        % difference by step_size.

        fprintf('--> UP by %f st\n', step_size);

        difference = difference + step_size;
        steps = [steps, step_size];
        differences = [differences, difference];

        % Reset decision vector
        decision_vector = [];
        
        swimming = false;
    else
        % Not going up nor down
        fprintf('--> STABLE\n');
        steps = [steps, 0];
        differences = [differences, difference];
        swimming = true;
    end

    % Update step_size
    if difference <= options.(phase).change_step_size_condition*step_size ...
            || mod(length(differences), options.(phase).change_step_size_n_trials)==0
        fprintf('--> Step size is getting updated: was %f st', step_size);
        step_size = step_size * options.(phase).step_size_modifier;
        fprintf(', is now %f st\n', step_size);
    end
    
end

