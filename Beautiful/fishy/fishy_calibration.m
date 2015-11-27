

% condition = 'target';
% condition = 'speech-shape-noise';
condition = 'normal'; tmr = 0;
speaker = 'M1';


%-----------------------------------------------------------------------

[training_1, training_2, test, options] = fishy_build_conditions();
x = [];

switch condition

    case 'target'
    
        %----------------------------------------------------
        % Calibration of CRM sentences
        %----------------------------------------------------

        for col = options.target.colours
            for num = options.target.numbers

                trial = struct();

                trial.target.speaker = speaker;
                trial.target.colour  = col;
                trial.target.number  = num;
                trial.target.call_sign = 7;

                trial.masker.type = 'speech';

                trial.masker.speaker = 'F1';
                trial.masker.colour  = options.masker.colours(1);
                trial.masker.number  = options.masker.numbers(1);
                trial.masker.call_sign = options.masker.call_signs(1);

                trial.tmr = Inf;

                trial.visual_feedback = 0;
                trial.audio_feedback  = 0;

                trial.i_repeat = 1;
                trial.done = 0;

                [z, fs, info_x, info_y, x_] = fishy_make_stim(options, trial);

                x = [x; z];

                
            end
        end

        
    case 'speech-shape-noise'
        %----------------------------------------------------
        % Calibration of speech shape noise
        %----------------------------------------------------

        for col = options.target.colours
            for num = options.target.numbers

                trial = struct();

                trial.target.speaker = speaker;
                trial.target.colour  = col;
                trial.target.number  = num;
                trial.target.call_sign = 7;

                trial.masker.type = 'speech-shape-noise';

                trial.masker.speaker = 'F1';
                trial.masker.colour  = col;
                trial.masker.number  = num;
                trial.masker.call_sign = 1;

                trial.tmr = -Inf;

                trial.visual_feedback = 0;
                trial.audio_feedback  = 0;

                trial.i_repeat = 1;
                trial.done = 0;

                
                [z, fs, info_x, info_y, x_] = fishy_make_stim(options, trial);

                x = [x; z];
                
            end
        end
        
    case 'normal'
    
        %----------------------------------------------------
        % Calibration of normal trials at 0 dB TMR
        %----------------------------------------------------

        for col = options.target.colours
            for num = options.target.numbers

                trial = struct();

                trial.target.speaker = speaker;
                trial.target.colour  = col;
                trial.target.number  = num;
                trial.target.call_sign = 7;

                %trial.masker.type = 'speech-shape-noise';
                trial.masker.type = 'speech';

                
                if speaker(1)=='M'
                    m_speaker = 'F';
                else
                    m_speaker = 'M';
                end
                
                trial.masker.speaker = sprintf('%s%d', m_speaker, randint(4));
                trial.masker.colour  = randpick(options.masker.colours, trial.target.colour);
                trial.masker.number  = randpick(options.masker.numbers, trial.target.number);
                trial.masker.call_sign = randpick(options.masker.call_signs);

                trial.tmr = tmr;

                trial.visual_feedback = 0;
                trial.audio_feedback  = 0;

                trial.i_repeat = 1;
                trial.done = 0;
                
                
                [z, fs, info_x, info_y, x_] = fishy_make_stim(options, trial);

                x = [x; z];

            end
        end

end


addpath('./pa_7');
addpath('./TDT_dummy');
%---------------------------------------------------------------------

disp(sprintf('==> Duration: %.1f s. RMS: %.1f dB.', size(x, 1)/fs, 20*log10(RMS(x(:, 1)))));

pa_init(options.fs);
setPA4(3, 0);
setPA4(4, 0);
setPA4(1, options.attenuation_dB);
setPA4(2, options.attenuation_dB);

player = audioplayer(x, fs, 16);
set(player, 'TimerFcn', @audioplayer_progressbar, 'TimerPeriod', .1, 'StopFcn', @audioplayer_stop);

disp('Playing...');
play(player);
disp('Done.');

X = abs(fft(x(:,1)));
f = (0:length(X)-1)/(length(X)-1)*fs;
fmax = 10000;
w = hann(512);
w = w / sum(w);
plot(f(f<fmax), conv2(20*log10(X(f<fmax)), w, 'same')) %, '-r')
