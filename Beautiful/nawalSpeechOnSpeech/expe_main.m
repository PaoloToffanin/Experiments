function expe_main(options, session)

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
        uiwait(h.f);

    end
    

    %=============================================================== MAIN LOOP
    
    this_session = [expe.test.conditions.session] == session;
    
    
    %Assumes you have a maximum of 2 sessions. Needs to be modified if
    %nsessions > 2
    if session > 1
        total_trials = length(expe.test.conditions);
    else
        total_trials = length(expe.test.conditions(this_session));
    end
    
    
    [~,name,~] = fileparts(options.sentence_bank);
    sentences = load(options.sentence_bank,name);
    sentences = sentences.(name);
    
    %Program scheduled breaks:
    nbreaks = options.nbreaks;
    breaktime = floor(length(expe.test.conditions)/(nbreaks+1));
    breaktime_trials = [breaktime:breaktime:length(expe.test.conditions)];
    breaktime_trials = breaktime_trials(1:nbreaks);
    

        while mean([expe.test.conditions(this_session).done])~=1  % Keep going while there are some conditions in this session left to do

            timestamp = datestr(now);
            % Find first condition not done
            i_condition = find([expe.test.conditions.done]==0 & [expe.test.conditions.session] == session, 1);
            fprintf('\n============================ Testing condition %d / %d ==========\n', i_condition, length(expe.test.conditions))
            condition = expe.test.conditions(i_condition);
            
            %Print the condition to the screen:
            disp(condition);
            
            %Always get timestamp for each trial.
            condition.timestamp = timestamp;

            if condition.vocoder==0
                fprintf('No vocoder\n\n');
            else
                fprintf('Vocoder: %s\n %s\n %s\n\n', options.vocoder(condition.vocoder).label, options.vocoder(condition.vocoder).parameters.analysis_filters.type);
            end


            %Include a break here:
            if sum(i_condition == breaktime_trials) > 0
          
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

    %% Training phase:
            if i_condition == 1

                training = expe.training;
                
                %1. Train on target WITHOUT masker:
                tic
                phase = 'training1';

                playTrain(h, options,training,phase,training.feedback,sentences);
                              
                %2. Train on target WITH masker. Give feedback.
                phase = 'training2';
                playTrain(h, options,training,phase,training.feedback,sentences);
                
                toc
                
                %3. Begin actual test. Control the experiment flow from another
                %gui 'g':
                phase = 'test';
                h.set_progress(strrep(phase, '_', ' '), i_condition, total_trials);
                instr = strrep(options.instructions.( phase ), '\n', sprintf('\n'));
                h.hide_instruction();
                h.set_instruction(instr);
                h.show_instruction();
                h.set_hstart_text('DOORGAAN');
                uiwait(h.f);
                pause(0.5)
            
                   
            end
            
            phase = 'test';
                     
            %Construct Experimenter GUI 'g':
            g = initExpGUI(expe,options); %construct experimenter gui.
            set(0,'currentfigure',g.f);
            g.set_progress(strrep(phase, '_', ' '), i_condition, total_trials);
            
            %Create Stimulus:
            [target,masker,sentence,fs] = expe_make_stim(options,condition,phase,i_condition);
            xOut = (target+masker)*10^(-options.attenuation_dB/20);
            
            %Vocode as necessary:
            if condition.vocoder > 0

                [xOut,fs] = vocodeStimulus(xOut,fs,options,condition.vocoder);

            end
            
            words = sentences{sentence};
            
            set(0,'currentfigure',g.f);
            g.init_buttons(words);
            
            set(0,'currentfigure',g.f);
            g.init_continue(words,i_condition,condition);
            
            set(0,'currentfigure',g.f);
            g.init_playbutton(xOut,fs);
            
            
            %Continue testing the same voice dir using different sentences.
            set(0,'currentfigure',h.f);
            h.hide_start();
            h.set_progress(strrep(phase, '_', ' '), i_condition, total_trials);
            
            
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
            expe.test.conditions(i_condition).done = 1;
            
            close(g.f);
            
       
        end
        
        set(0,'currentfigure',h.f);
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

function playTrain(h, options,condition,phase,feedback,sentences)
   
    instr = strrep(options.instructions.( phase ), '\n', sprintf('\n'));

    h.set_instruction(instr);
    h.show_instruction();
    h.set_hstart_text('DOORGAAN');
    h.enable_start();
    h.show_start();

    h.make_visible(); 

    uicontrol(h.hstart);
    uiwait(h.f);

    for i = 1:options.training.nsentences
        h.set_progress(strrep(phase, '_', ' '), i, options.training.nsentences);
        h.set_hstart_text('GA VERDER');

        %Instruct to Listen to the target:
        instr = strrep(options.instructions.listen, '\n', sprintf('\n'));
        h.hide_instruction();
        h.set_instruction(instr);
        h.show_instruction();
        h.disable_start();

        %Generate Masker and target:
        [target,masker,sentence,fs] = expe_make_stim(options,condition,phase,i);
        xOut = (target+masker)*10^(-options.attenuation_dB/20);

        x = audioplayer(xOut,fs,16);
        playblocking(x);
        pause(0.5);

        %Instruct to Repeat the target sentence
        instr = strrep(options.instructions.repeat, '\n', sprintf('\n'));
        h.hide_instruction();
        h.set_instruction(instr);
        h.show_instruction();

        h.enable_start();
        uiwait(h.f);

        if feedback
            %Give feedback by displaying the sentence:
            h.disable_start();
            feedback_sent = sentences{sentence};
            instr = strrep(options.instructions.feedback, '\n', sprintf('\n'));
            h.hide_instruction();
            h.set_instruction([instr feedback_sent]);
            h.show_instruction();
            pause(2); %wait for 2 sec before playing the stimulus again.
            
            %Play stimulus again for audio feedback:
            x = audioplayer(xOut,fs,16);
            playblocking(x);
            pause(0.5);
            
            %Resume
            h.enable_start();
            uiwait(h.f);
            pause(0.5)
        end

        

    end

end


function [stim,fs] = vocodeStimulus(x,fs, options,voc)

        
        [stim, fs] = vocode(x, fs, options.vocoder(voc).parameters);          
        stim = stim(:);

        %This prevents the wavwrite from clipping the data
        m = max(abs(min(stim)),max(stim)) + 0.001;
        stim = stim./m;

end