function sos_main(options, phase)
% function sos_main(options, session)

    %Init GUIs
    %Experiment is defined here!

    load(options.res_filename); % options, expe, results
    

%Provide starting instructions
    instr = strrep(options.instructions.start, '\n', sprintf('\n'));
    if ~isempty(instr)
        
        h = initSubjGUI(options);

        drawnow()
        
        h.set_instruction(instr);
        h.set_hstart_text('BEGIN');

        movegui(h.f,'center')
        h.make_visible(); 

        uicontrol(h.hstart);
%         uiwait(h.f);

    end
    %=============================================================== MAIN LOOP
    
    corpus = parseCorpus(options);% as such we are doing it twice, also in line 61 of expe_build_conditions
    sentences = {corpus.sentence};
    
% Keep going while there are some conditions in this session left to do
%     while mean([expe.test.conditions(this_session).done])~=1
        
    %% Training phase:
    if strcmp(phase, 'training')
        training = expe.training;
        
        %1. Train on target WITHOUT masker:
        %                 tic
        %                 phase = 'training1';
        %                 playTrain(h, options,training,phase,training.feedback,sentences);
        
        %2. Train on target WITH masker. Give feedback.
        phase = 'training2';
        failed = playTrain(h, options,training,phase,training.feedback,sentences);
        if failed
            return
        end
    else
        %Program scheduled breaks:
        total_trials = length(expe.(phase).conditions);
        nbreaks = options.nbreaks;
        breaktime = floor(total_trials/(nbreaks+1));
        breaktime_trials = [breaktime : breaktime : total_trials];
        breaktime_trials = breaktime_trials(1:nbreaks);
        
        while mean([expe.(phase).conditions.done])~=1
            timestamp = datestr(now);
            % Find first condition not done
            % N:        iTrial = find([expe.test.conditions.done]==0 & [expe.test.conditions.session] == session, 1);
            iTrial = find([expe.test.conditions.done] == 0, 1);
            fprintf('\n=========== trial %s %d of %d ==========\n', ...
                expe.(phase).conditions.maskerVoice, iTrial, total_trials);
            condition = expe.test.conditions(iTrial);
            
            %Print the condition to the screen:
            disp(condition);
            
            %Always get timestamp for each trial.
            condition.timestamp = timestamp;
            
            if condition.vocoder==0
                fprintf('No vocoder\n\n');
            else
                fprintf('Vocoder: %s\n %s\n %s\n\n', ...
                    options.vocoder(condition.vocoder).label, ...
                    options.vocoder(condition.vocoder).parameters.analysis_filters.type);
            end
            
            if iTrial == 1
                %3. Begin actual test. Control the experiment flow from another
                %gui 'g':
                phase = 'test';
                h.set_progress(strrep(phase, '_', ' '), iTrial, total_trials);
                instr = strrep(options.instructions.(phase), '\n', sprintf('\n'));
                h.hide_instruction();
                h.set_instruction(instr);
                h.show_instruction();
                h.set_hstart_text('DOORGAAN');
                uiwait(h.f);
                pause(0.5)
            end
            
            %Include a break here:
            if sum(iTrial == breaktime_trials) > 0
                char(questdlg(sprintf('Time for a break!!'),'SOS','OK','OK'));
                instr = strrep(options.instructions.breaktime, '\n', sprintf('\n'));
                h.set_instruction(instr);
                h.show_instruction();
                h.set_hstart_text('DOORGAAN');
                h.enable_start();
                h.show_start();
                uicontrol(h.hstart);
                uiwait(h.f);
            end
            %Construct Experimenter GUI 'g':
            g = initExpGUI(expe,options); %construct experimenter gui.
            set(0,'currentfigure',g.f);
            g.set_progress(strrep(phase, '_', ' '), iTrial, total_trials);
            
            %Create Stimulus:
%             [target, masker, sentence, fs] = expe_make_stim(options, condition, phase, iTrial);
            [target, masker, sentence, fs] = sos_make_stim(options, condition, phase, iTrial);
            xOut = (target+masker)*10^(-options.attenuation_dB/20);
            
            %Vocode as necessary:
            if condition.vocoder > 0
                [xOut,fs] = vocodeStimulus(xOut, fs, options, condition.vocoder);
            end
            
            % N:        words = sentences{sentence};
            words = corpus(sentence).sentence;
            
            set(0,'currentfigure',g.f);
            g.init_buttons(words);
            
            set(0,'currentfigure',g.f);
            g.init_continue(words, iTrial, condition);
            
            set(0,'currentfigure',g.f);
            g.init_playbutton(xOut,fs);
            
            
            %Continue testing the same voice dir using different sentences.
            set(0,'currentfigure',h.f);
            h.hide_start();
            h.set_progress(strrep(phase, '_', ' '), iTrial, total_trials);
            
            
            %Instruct to Listen to the target:
            instr = strrep(options.instructions.listen, '\n', sprintf('\n'));
            h.hide_instruction();
            h.set_instruction(instr);
            h.show_instruction();
            
            uiwait(g.f);
            
            
            %wait until experimenter is done entering the responses and
            %saving:
            while g.get_contFlag() == 0
                uiwait(g.f);
            end
            
            g.set_contFlag(0);
            
            %Remove Listen instruction
            h.hide_instruction();
            
            
            %mark that this trial is done.
            expe.test.conditions(iTrial).done = 1;
            
            close(g.f);
            
        end
    end
    
    set(0, 'currentfigure', h.f);
    instr = strrep(options.instructions.end, '\n', sprintf('\n'));
    h.hide_instruction();
    h.set_instruction(instr);
    h.show_instruction();
    h.set_hstart_text('VOLTOOIEN');
    h.enable_start();
    h.show_start();
    
    uiwait(h.f);
    close(h.f);
    
    
    
    %end
end




