function gender_main(expe, options, phase)

    results = struct();
    
    starting = 0;

    autoplayer = false;
    if strcmp(options.subject_name, 'test');
        autoplayer = true;
    end

    %% ------------- Game
    if (mean([expe.(phase).trials.done])~=1)
        [G, TVScreen, Buttonup, Buttondown, Speaker, gameCommands, Hands] = gender_game(options);
        G.onMouseRelease = @buttondownfcn;
        G.onKeyPress = @keypressfcn;
    else
        opt = char(questdlg(sprintf('%s phase COMPLETE. Run again?', phase),['Re-run ' phase],'Yes','No','Yes'));
        switch opt
            case 'Yes'
                if ~strcmp(options.subject_name, 'tryout');
                    resultsFiles = dir([options.result_path '/*.mat']);
                    nRep = length(resultsFiles) - sum(cellfun('isempty', regexp({resultsFiles.name}, options.subject_name)));
                    nRep = nRep + 1;
                    options.subject_name  = sprintf('%s%s_%02.0f.mat', options.result_prefix, options.subject_name, nRep);
                    options.res_filename = fullfile(options.result_path, options.subject_name);
                    [G, TVScreen, Buttonup, Buttondown, Speaker, gameCommands, Hands] = gender_game(options);
                    G.onMouseRelease = @buttondownfcn;
                    G.onKeyPress = @keypressfcn;
                end
                [expe, options] = gender_buildingconditions(options);
            case 'No'
                return
        end
    end

%=============================================================== MAIN LOOP
    while mean([expe.(phase).trials.done])~=1 % Keep going while there are some trials to do
    
     
        if autoplayer 
            starting = 1;
            gameCommands.State = 'empty';
        end
        % If we start, display a message
        if starting == 0
            uiwait();
        end   
        % Find first trial not done
        itrial = find([expe.( phase ).trials.done]==0, 1);
        trial = expe.( phase ).trials(itrial); 
        
        TVScreen.State = 'off';
        Buttonup.State = 'off';
        Buttondown.State = 'off';
        pause(1);
        TVScreen.State = 'noise'; 
    
        [xOut, fs] = gender_make_stim(options, trial);

        player = audioplayer(xOut, fs, 16);
        
        pause(.5);
        iter = 1;
        
        play(player)
        while true
            TVScreen.State = 'noise'; 
            Speaker.State = ['TVSpeaker_' sprintf('%i', mod(iter, 2)+1)];
            iter = iter + 1;
            pause(0.01);
            if ~isplaying(player)
                Speaker.State = 'off';
                break;
            end
        end

        % why is this here?
%         if ~autoplayer
%             uiwait
%         end

        locHand = 1;
        if (strncmp(expe.(phase).trials(itrial).hands, 'handremote',10))
            locHand = 2;
        end
        for handstate = 1:2
            Hands.State = sprintf('%s%d', expe.(phase).trials(itrial).hands, handstate);
            Hands.Location = [Hands.locHands{locHand}];
            if ~autoplayer
                pause (0.2)
            end
        end
        if ~autoplayer
            pause (0.4)
        end
        Hands.State = 'off';
        if ~autoplayer
            pause(0.5)
        end
        TVScreen.State = expe.(phase).trials(itrial).face;
        if ~autoplayer
            pause(0.6)
        end
        Buttonup.State = 'on';
        Buttondown.State = 'on';
        
        if autoplayer
            response.button_clicked = randi([0, 1], 1, 1); % default in case they click somewhere else
            response.response_time = 0; 
            response.timestamp = now;
        else
            tic();
            uiwait();
            response.response_time = toc;
            response.timestamp = now;
        end
        response.trial = trial;
        if ~isfield(results, phase)
            results.( phase ).responses = orderfields( response );
        else
            results.( phase ).responses(end+1) = orderfields( response );
        end
        
        expe.( phase ).trials(itrial).done = 1;
        
        save(options.res_filename, 'options', 'expe', 'results')
    
        if itrial == options.(phase).total_ntrials
                gameCommands.Scale = 2; 
                gameCommands.State = 'finish';
        end
    end

%%     
    function buttondownfcn(hObject, callbackdata)
        
        locClick = get(hObject,'CurrentPoint');
        
        if starting == 1
            
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = 0; % default in case they click somewhere else
            
            if (locClick(1) >= Buttonup.clickL) && (locClick(1) <= Buttonup.clickR) && ...
                    (locClick(2) >= Buttonup.clickD) && (locClick(2) <= Buttonup.clickU)
                Buttonup.State = 'press';
                response.button_clicked = 1;
            end
            
            if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                    (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                Buttondown.State = 'press'; 
                response.button_clicked = 2;
            end
            
            % continue if only one of the two buttons is clicked upon
            % otheriwse not
            if response.button_clicked ~= 0
                pause(0.5)
                Buttonup.State = 'off';
                Buttondown.State = 'off';
                fprintf('Clicked button: %d\n', response.button_clicked);
                fprintf('Trials: %d\n', itrial);
                fprintf('Response time : %d ms\n\n', round(response.response_time*1000));
                uiresume
            end
            
        else
             if (locClick(1) >= gameCommands.clickL) && (locClick(1) <= gameCommands.clickR) && ...
                (locClick(2) >= gameCommands.clickD) && (locClick(2) <= gameCommands.clickU)
             starting = 1;
             gameCommands.State = 'empty';
             pause (1)
             uiresume();
             end
        end
    end % end buttondown fcn

    function keypressfcn(~,e)
        if strcmp(e.Key, 'control') % OR 'space'
            uiresume;
            tic();
        end
    end
   
    % close current figure
    close gcf
end



