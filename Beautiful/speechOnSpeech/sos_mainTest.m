% N: function sos_main(options, session)
% PT: replaced session with phase since session was not used very often
function sos_mainTest(options, phase)

% sos_run

    %Init GUIs
    %Experiment is defined here!
    if exist([options.result_path options.res_filename], 'file')
        load([options.result_path options.res_filename]); % options, expe, results
    else
        error('file %s\n does not exists', [options.result_path options.res_filename]);
    end

%Provide starting instructions
    instr = strrep(options.instructions.start, '\n', sprintf('\n'));
    if ~isempty(instr)
        
%         h = initSubjGUI(options); % PT: options isn't used!
        h = initSubjGUI;

        drawnow()
%         set(h.f, 'Visible', 'on');
        
        h.set_instruction(instr);
        h.set_hstart_text('START');

        movegui(h.f,'center')
        h.make_visible(); 

        uicontrol(h.hstart);
        uiwait(h.f);

    end
    
    
    SIMUL = 0;

    beginning_of_session = now();

    %=============================================================== MAIN LOOP
    
%N    this_session = [expe.test.conditions.session] == session;
% % PT this_session is replace by itrial
%    itrial = 1;
% % PT this_session is not a counter but a vector with the trials that
% should be performed in this session... I think it can be removed all
% together, since we specify training and test before hand.
% i_condition should be replaced with itrial

    %not_done = [expe.test.conditions(this_session).done];
    
    %Assumes you have a maximum of 2 sessions. Needs to be modified if
    %nsessions > 2
%N    if session > 1
%N        total_trials = length(expe.test.conditions);
%N    else
%N        total_trials = length(expe.test.conditions(this_session));
%N    end

%     switch session 
%         case 1
%             phase = 'training';

%             total_trials = length(expe.(phase).trial);
            total_trials = 5;
%         case 2
%             phase = 'test';
%             total_trials = length(expe.(phase).trial);
%     end
    

%     prev_dir_voice = []; PT: unused
    
%     prev_TMR = []; PT: unused
%     vocoded_section = 0; PT: unused
    
% % PT: replaces this with  expe.(phase).trial.target_sentence  
%     [~, name, ext] = fileparts(options.sentence_bank);
%     sentences = load(options.sentence_bank, name);
%     sentences = sentences.(name);

%     expe.test.trial.target_sentence

    %Assign 4 scheduled breaks:
    % PT: training is 12 sentences so no breaks
    breaktime_trials = 0;
    if strcmp(phase, 'test')
        nbreaks = 4;
        
        % % PT: from here on in the expe structure conditions is replaced by trial
        %N    breaktime = floor(length(expe.test.conditions)/(nbreaks+1));
        %N    breaktime_trials = [breaktime : breaktime : length(expe.test.conditions)];
        %N    breaktime_trials = breaktime_trials(1 : nbreaks);
        breaktime = floor(length(expe.(phase).trial)/(nbreaks+1));
        breaktime_trials = [breaktime : breaktime : length(expe.(phase).trial)];
        breaktime_trials = breaktime_trials(1 : nbreaks);
    end
    
    prev_voc = 0;

%     while mean([expe.(phase).trial(itrial).done]) ~= 1  % Keep going while there are some conditions in this session left to do
    for itrial = 1 : total_trials % length(expe.(phase).trial)
        
% N:        timestamp = datestr(now); % PT: added directly to structure
        % Find first condition not done
% % PT: i_condition replaced by itrial 
%         i_condition = find([expe.(phase).conditions.done] == 0 & ...
%             [expe.(phase).conditions.session] == session, 1);
%         itrial = itrial + 1; but the number of trials is already
%         predefined!!!
%         fprintf('\n============================ Testing condition %d / %d ==========\n', ...
%             i_condition, length(expe.(phase).conditions))
%         condition = expe.(phase).conditions(i_condition);
        fprintf('\n trial %d of %d \n', ...
            itrial, length(expe.(phase).trial))
        fprintf('%s\n', expe.(phase).trial(itrial).target_sentence);
        
        condition = expe.(phase).trial(itrial);
        %Print the condition to the screen:
%         condition
        
% E:        %Always get timestamp for each trial.
% N:        condition.timestamp = timestamp;
% PT:
        condition.timestamp = datestr(now);

        if ~isfield(condition, 'vocoder')
            fprintf('No vocoder\n\n');
            condition.vocoder = NaN;
        else
            fprintf('Vocoder: %s\n %s\n %s\n\n', ...
                options.vocoder(condition.vocoder).label, ...
                options.vocoder(condition.vocoder).parameters.analysis_filters.type);
        end


        %Include a break here:
%         if sum(i_condition == breaktime_trials) > 0
        if sum(itrial == breaktime_trials) > 0
        %if (condition.vocoder > 0) && (vocoded_section == 0)
            instr = strrep(options.instructions.breaktime, '\n', sprintf('\n'));
            h.set_instruction(instr);
            h.show_instruction();
            h.set_hstart_text('CONTINUE');
            h.enable_start();
            h.show_start();
            uicontrol(h.hstart);
            uiwait(h.f);

%                     vocoded_section = 1; %display instructions once vocoded section begins
%                     instr = strrep(options.instructions.vocoded, '\n', sprintf('\n'));
%                     h.set_instruction(instr);
%                     h.set_hstart_text('CONTINUE');
%                     h.enable_start();
%                     h.show_start();
%                     uicontrol(h.hstart);
%                     uiwait(h.f);
        end

%% Training phase:
        %if isempty(prev_dir_voice) || prev_dir_voice ~= condition.dir_voice
%             if isempty(prev_TMR) || prev_TMR ~= condition.TMR || prev_voc ~= condition.vocoder
%         if i_condition == 1
        if (mod(itrial, 6) == 1)
% % PT: this bit does not do anything since it is commented out           
%             training = expe.training;
% 
%             %1. Train on target WITHOUT masker:
%             tic
%             phase = 'training1';
% 
%             %playTrain(h, options,training,phase,training.feedback,sentences);
% 
%             %2. Train on target WITH masker. Give feedback.
%             phase = 'training2';
%             %playTrain(h, options,training,phase,training.feedback,sentences);
% 
%             toc
% % PT: end
            %3. Begin actual test. Control the experiment flow from another
            %gui 'g':
%             phase = 'test'; % PT: this overwrites the training phase
%             h.set_progress(strrep(phase, '_', ' '), i_condition, total_trials);
            if strcmp(phase, 'test')
                h.set_progress(phase, itrial, total_trials);
                instr = strrep(options.instructions.(phase), ...
                    '\n', sprintf('\n'));
            else
                h.set_progress(strrep(phase, '_', ' '), itrial, total_trials);
                instr = strrep(options.instructions.(expe.(phase).trial(itrial).(phase)), ...
                    '\n', sprintf('\n'));

            end
            h.hide_instruction();
            h.set_instruction(instr);
            h.show_instruction();
            h.set_hstart_text('CONTINUE');
            % PT: added these below so that the instructions can change
            % dureing ther training
            h.enable_start();
            h.show_start();
            
            uiwait(h.f);
            pause(0.5)
            % we need to find a way to let the second phase start... it
            % might be a problem with the screen settings, the experimenter
            % should make him/her start, or should the experimenter have a
            % continue/start button?


        end

% PT:        phase = 'test'; % phase is now specified as input to the
% function

        %Construct Experimenter GUI 'g':
        g = initExpGUI(expe, options);
        set(0,'currentfigure',g.f);
% N:        g.set_progress(strrep(phase, '_', ' '), i_condition, total_trials);
        g.set_progress(strrep(phase, '_', ' '), itrial, total_trials);

        %Create Stimulus:
% N:        [target,masker,sentence,fs] = expe_make_stim(options,condition,phase,i_condition);
        [target, masker, sentence, fs] = sos_make_stim(options, condition, phase, itrial);
        xOut = (target+masker)*10^(-options.attenuation_dB/20);

        figure
        plot((1:length(target))/fs, target, '-b', (1:length(masker))/fs,masker,'-r')
        plot((1:length(masker))/fs,masker,'-r', (1:length(target))/fs, target, '-b')
%         ax = gca;
% ax.XTick 
        %Vocode as necessary:
% N        if condition.vocoder > 0
        if ~isnan(condition.vocoder)
            [xOut,fs] = vocodeStimulus(xOut, fs, options, condition.vocoder);
        end

% N:        words = sentences{sentence};
        words = expe.(phase).trial(itrial).target_sentence;

        set(0,'currentfigure',g.f);
        g.init_buttons(words);

        set(0,'currentfigure',g.f);
% N:         g.init_continue(words,i_condition,condition);
        g.init_continue(words, itrial, condition);

        set(0,'currentfigure',g.f);
        g.init_playbutton(xOut,fs);


        %Continue testing the same voice dir using different sentences.
        set(0,'currentfigure',h.f);
        h.hide_start();
% N:        h.set_progress(strrep(phase, '_', ' '), i_condition, total_trials);
        h.set_progress(strrep(phase, '_', ' '), itrial, total_trials);


        %Instruct to Listen to the target:
        instr = strrep(options.instructions.listen, '\n', sprintf('\n'));
        h.hide_instruction();
        h.set_instruction(instr);
        h.show_instruction();

        uiwait(g.f);

        %Instruct to Repeat the target sentence
%             instr = strrep(options.instructions.repeat, '\n', sprintf('\n'));
%             h.hide_instruction();
%             h.set_instruction(instr);
%             h.show_instruction();

        %wait until experimenter is done entering the responses and
        %saving:
        while g.get_contFlag() == 0
            uiwait(g.f);
        end

        g.set_contFlag(0);
        %close(h.f);

        %Remove Listen instruction
        h.hide_instruction();

        %keep track of the dir voice to know whether you should train
        %subjs if the dir voice changes:
%             prev_dir_voice = condition.dir_voice;
        prev_TMR = condition.TMR;

        %mark that this trial is done.
% N:        expe.test.conditions(i_condition).done = 1;
        expe.test.conditions(itrial).done = 1;
        close(g.f);
        
        if isfield(condition, 'vocoder')
            prev_voc = condition.vocoder;
        end

    end

    set(0,'currentfigure',h.f);
    instr = strrep(options.instructions.end, '\n', sprintf('\n'));
    h.hide_instruction();
    h.set_instruction(instr);
    h.show_instruction();
    h.set_hstart_text('FINISH');
    h.enable_start();
    h.show_start();

    uiwait(h.f);
    close(h.f);

end

% PT: this function is never used
% function playTrain(h, options, condition, phase, feedback, sentences)
%    
%     instr = strrep(options.instructions.( phase ), '\n', sprintf('\n'));
% 
%     h.set_instruction(instr);
%     h.show_instruction();
%     h.set_hstart_text('CONTINUE');
%     h.enable_start();
%     h.show_start();
% 
%     h.make_visible(); 
% 
%     uicontrol(h.hstart);
%     uiwait(h.f);
% 
%     for i = 1:options.training.nsentences
%         h.set_progress(strrep(phase, '_', ' '), i, options.training.nsentences);
%         h.set_hstart_text('NEXT');
% 
%         %Instruct to Listen to the target:
%         instr = strrep(options.instructions.listen, '\n', sprintf('\n'));
%         h.hide_instruction();
%         h.set_instruction(instr);
%         h.show_instruction();
%         h.disable_start();
% 
%         %Generate Masker and target:
%         [target,masker,sentence,fs] = expe_make_stim(options,condition,phase,i);
%         xOut = (target+masker)*10^(-options.attenuation_dB/20);
%         
%         %Vocode as necessary:
% %         if condition.vocoder > 0
% %             
% %             [xOut,fs] = vocodeStimulus(xOut,fs,options,condition.vocoder);
% %             
% %         end
% 
%         x = audioplayer(xOut,fs,16);
%         playblocking(x);
%         pause(0.5);
% 
%         %Instruct to Repeat the target sentence
%         instr = strrep(options.instructions.repeat, '\n', sprintf('\n'));
%         h.hide_instruction();
%         h.set_instruction(instr);
%         h.show_instruction();
% 
%         h.enable_start();
%         uiwait(h.f);
% 
%         if feedback
%             %Give feedback by displaying the sentence:
%             h.disable_start();
%             feedback_sent = sentences{sentence};
%             instr = strrep(options.instructions.feedback, '\n', sprintf('\n'));
%             h.hide_instruction();
%             h.set_instruction([instr feedback_sent]);
%             h.show_instruction();
%             pause(2); %wait for 2 sec before playing the stimulus again.
%             
%             %Play stimulus again for audio feedback:
%             x = audioplayer(xOut,fs,16);
%             playblocking(x);
%             pause(0.5);
%             
%             %Resume
%             h.enable_start();
%             uiwait(h.f);
%             pause(0.5)
%         end
% 
%         
% 
%     end
% 
% end


function [stim,fs] = vocodeStimulus(x,fs, options,voc)

        
        [stim, fs] = vocode(x, fs, options.vocoder(voc).parameters);          
        stim = stim(:);

        %This prevents the wavwrite from clipping the data
        m = max(abs(min(stim)),max(stim)) + 0.001;
        stim = stim./m;

end