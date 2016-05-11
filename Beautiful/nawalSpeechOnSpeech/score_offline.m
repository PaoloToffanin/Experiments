function score_offline(subject,rescore_all, varargin)

%% Check if subject data exist:

result_path   = './results';
result_prefix = 'SOS_';

res_foldername = fullfile(result_path, sprintf('%s%s', result_prefix, subject));

res_filename = fullfile(res_foldername, sprintf('%s%s.mat', result_prefix, subject));

if ~exist(res_foldername, 'dir')
    opt = char(questdlg(sprintf('The subject "%s" doesn''t exist. Please enter a valid subject ID.', subject),...
        'SOS','OK','OK'));
    return
else
    opt = char(questdlg(sprintf('Found "%s". Use this data?', res_foldername),'SOS','OK','Cancel','OK'));
    if strcmpi(opt, 'Cancel')
        return
    else
        load(res_filename);
    end
end


%Find all wav files that begin with 'Condition'
current_dir = cd;
cd(options.res_foldername);
wavfiles = dir('*.flac');
cd(current_dir);

n = length(wavfiles);

wavfilenames = {wavfiles.name};
[wavfilenames,~] = sort_nat(wavfilenames);

for i = 1:n

    
    if ~rescore_all
        
        if ~isempty(varargin)
            h = score_offline_GUI(expe,options);
            sentence = results(varargin{1}).sentence;

            [soundfile,fs] = audioread(fullfile(options.res_foldername,wavfilenames{varargin{1}}));

            h.set_progress('Trial', varargin{1}, n);
            h.init_buttons(sentence);
            h.init_continue(sentence,varargin{1});
            h.init_playbutton(soundfile,fs); 

            uiwait(h.f);

            %wait until experimenter is done entering the responses and
            %saving:
            while h.get_contFlag() == 0
                uiwait(h.f);
            end

            h.set_contFlag(0);
            close(h.f)
            break
        
        elseif ~isfield(results,'words_offline') || isempty(results(i).nwords_correct_offline)

            h = score_offline_GUI(expe,options);
            sentence = results(i).sentence;

            [soundfile,fs] = audioread(fullfile(options.res_foldername,wavfilenames{i}));

            h.set_progress('Trial', i, n);
            h.init_buttons(sentence);
            h.init_continue(sentence,i);
            h.init_playbutton(soundfile,fs); 

            uiwait(h.f);

            %wait until experimenter is done entering the responses and
            %saving:
            while h.get_contFlag() == 0
                uiwait(h.f);
            end

            h.set_contFlag(0);
            close(h.f)
        end
    else
        sentence = results.sentence;

        [soundfile,fs] = audioread(fullfile(options.res_foldername,wavfilenames{i}));

        h.set_progress('Trial', i, n);
        h.init_buttons(sentence);
        h.init_continue(sentence,i);
        h.init_playbutton(soundfile,fs); 

        uiwait(h.f);

        %wait until experimenter is done entering the responses and
        %audio responses are saved:
        while h.get_contFlag() == 0
            uiwait(h.f);
        end

        h.set_contFlag(0);
        close(h.f)
    end
end

questdlg(sprintf('Success! All executed conditions have now been ranked offline.\n'),'Offline Ranking','OK','OK');


end