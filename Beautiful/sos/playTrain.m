function failed = playTrain(h, options,condition,phase,feedback,sentences)
   
    failed = false;
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
        [target, masker, sentence, fs] = expe_make_stim(options, condition, phase, i);
%         [target, masker, sentence, fs] = sos_make_stim(options, condition, phase, i);
        if isempty(masker) || isempty(target)
            disp('target or masker are empty')
            failed = true;
            return;
        end
        xOut = (target+masker)*10^(-options.attenuation_dB/20);

        size(xOut)
        disp(phase)
        disp(sentence)
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