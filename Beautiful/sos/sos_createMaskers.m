function sos_createMaskers(options)

% N    [~, options] = expe_build_conditions(options);
    [~, options] = sos_build_conditions(options);

    tic()

    phases = {'training', 'test'};
    nPhases = length(phases);
    for phase = 1 : nPhases

        maskerList = [];
        for i_masker_list = 1 : length(options.masker)        
            masker_list = options.masker(i_masker_list);
            masker_sentences = options.list{masker_list}(1):options.list{masker_list}(2);
            maskerList = [maskerList masker_sentences];
        end
        nMaskers = length(maskerList);
        %maskerList = options.masker(1):options.masker(2);
        nconditions = length(options.(phases{phase}).voices);
        nMasks = length(options.maskerSex);
        for maskerVoice  = 1 : nMasks
            for iVoices = 1 : nconditions
                for file = 1 : nMaskers
                    % N:            [masker, fs] = straight_process(maskerList(file), f0, ser, options);
                    disp('-----------')
                    disp(['File ' num2str(maskerList(file))])
                    disp('-----------')
                    disp([num2str(iVoices) '/' num2str(nconditions)])
                    disp('-----------')
                    
                    straight_process(maskerList(file), ...
                        options.(phases{phase}).voices(iVoices).f0, ...
                        options.(phases{phase}).voices(iVoices).ser, ...
                        options, maskerVoice);
                end
            end
        end
    end
    toc()
end % end: function expe_process_masker_list_offline

%% straight processing
% N: function [y, fs] = straight_process(sentence, t_f0, ser, options)
function straight_process(sentence, t_f0, ser, options, maskerVoice)

% N:    wavIn = fullfile(options.sound_path, ['Vrouw' num2str(sentence), '.wav']);
    wavIn = [options.sound_path options.maskerSex{maskerVoice} num2str(sentence) '.wav'];
% N:    wavOut = make_fname(wavIn, t_f0, ser, options.tmp_path);
    wavOut = [options.tmp_path 'M_' options.maskerSex{maskerVoice} ...
        sprintf('%i_GPR%.2f_SER%.2f', sentence, t_f0, ser) '.wav'];
    
    if ~ exist(wavOut, 'file')
        mat = strrep(wavIn, '.wav','.straight.mat');
        if exist(mat, 'file')
            load(mat);
        else
            [x, fs] = audioread(wavIn);
            [f0, ap] = exstraightsource(x, fs);

            sp = exstraightspec(x, f0, fs);
            x_rms = rms(x);

            save(mat, 'fs', 'f0', 'sp', 'ap', 'x_rms');
        end
        f0(f0~=0) = f0(f0~=0) .* t_f0;
        p.frequencyAxisMappingTable = ser;
        y = exstraightsynth(f0, sp, ap, fs, p);
        y = y/rms(y)*x_rms;
        if max(abs(y))>1
            warning('Output was renormalized for "%s".', wavOut);
            y = 0.98*y/max(abs(y));
        end
        audiowrite(wavOut, y, fs);
    end
end % end: function [y, fs] = straight_process(sentence, t_f0, ser, options)

%% 
% function fname = make_fname(wav, f0, ser, destPath)
% 
%     [~, name, ext] = fileparts(wav);
%     
%     fname = sprintf('M_%s_GPR%.2f_SER%.2f', name, f0, ser);
%    
%     fname = fullfile(destPath, [fname, ext]);
% end
% 
