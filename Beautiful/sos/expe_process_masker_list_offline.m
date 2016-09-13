function expe_process_masker_list_offline(options)
%N: function expe_process_masker_list_offline()

%Create Masker Straight matrices offline:

% if is_test_machine() %If it's computer in Tinnitus Room
%     disp('-------------------------');
%     disp('--- In Tinnitus Room ---');
%     disp('-------------------------');
%     options.sound_path = '/Users/dbaskent/Sounds/VU_zinnen/Vrouw/equalized';
%     options.tmp_path   = '/Users/dbaskent/Sounds/VU_zinnen/Vrouw/processed';
% 
% else %If it's experimenter's OWN computer:
%     disp('-------------------------');
%     disp('--- On coding machine ---');
%     disp('-------------------------');
%     options.sound_path = '~/Library/Matlab/Sounds/VU_zinnen/Vrouw/equalized';
%     options.tmp_path   = '~/Library/Matlab/Sounds/VU_zinnen/Vrouw/processed';
% end

% options.sound_path = '~/sounds/VU_zinnen/sentences/';
% options.tmp_path   = '~/sounds/VU_zinnen/VU_zinnen/Vrouw/processed';
%     
%     filename = fullfile(options.tmp_path, sprintf('options.mat'));
%     options.filename = filename;
%     
%  
% %-------------------------------------------------
% 
% current_dir = fileparts(mfilename('fullpath'));
% added_path  = {};
% 
% added_path{end+1} = '~/Experiments/Beautiful/lib/vocoder_2015';
% addpath(added_path{end});
% 
% added_path{end+1} = '~/Experiments/Beautiful/lib/STRAIGHTV40_006b';
% addpath(added_path{end});
% 
% added_path{end+1} = '~/Experiments/Beautiful/lib/MatlabCommonTools';
% addpath(added_path{end});

[expe, options] = expe_build_conditions(options);

tic()

phase = {'training', 'test'};

for j = 1:length(phase);
    nconditions = length(options.(phase{j}).voices) ;
    
    maskerList = [];
    for i_masker_list = 1:length(options.masker)
        
        masker_list = options.masker(i_masker_list);
        masker_sentences = options.list{masker_list}(1):options.list{masker_list}(2);
        maskerList = [maskerList masker_sentences];

    end

    %maskerList = options.masker(1):options.masker(2);

    for i = 1:nconditions

        for file = 1:length(maskerList)
            disp('-----------')
            disp(['File ' num2str(maskerList(file))])
            disp('-----------')
            disp([num2str(i) '/' num2str(nconditions)])
            disp('-----------')

            f0 = options.(phase{j}).voices(i).f0
            ser = options.(phase{j}).voices(i).ser

            [masker, fs] = straight_process(maskerList(file), f0, ser, options);

        end

    end
end

toc()

end % end: function expe_process_masker_list_offline

%% straight processing
function [y, fs] = straight_process(sentence, t_f0, ser, options)
%
    wavIn = fullfile(options.sound_path, ['Vrouw' num2str(sentence), '.wav']);
    wavOut = make_fname(wavIn, t_f0, ser, options.tmp_path);

    if ~exist(wavOut, 'file')


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

    else



        [y, fs] = audioread(wavOut);
    end
end % end: function [y, fs] = straight_process(sentence, t_f0, ser, options)

%% 
function fname = make_fname(wav, f0, ser, destPath)

    [~, name, ext] = fileparts(wav);
    
    fname = sprintf('M_%s_GPR%.2f_SER%.2f', name, f0, ser);
   
    fname = fullfile(destPath, [fname, ext]);
end

