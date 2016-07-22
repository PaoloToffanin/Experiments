function db_filename = expe_to_sql()

addpath('/Users/nawalelboghdady/Library/Matlab/mksqlite-1.14');

current_dir = fileparts(mfilename('fullpath'));
added_path  = {};

added_path{end+1} = '~/Library/Matlab/auditory-research-tools/vocoder_2015';
addpath(added_path{end});

added_path{end+1} = '~/Library/Matlab/auditory-research-tools/STRAIGHTV40_006b';
addpath(added_path{end});

added_path{end+1} = '~/Library/Matlab/auditory-research-tools/common_tools';
addpath(added_path{end});

%-- Specify results path

options.result_path   = './results';
options.result_prefix = 'SOS_';

lst = dir(fullfile(options.result_path, [options.result_prefix, '*']));
files = { lst.name };

db_filename = fullfile(options.result_path, [options.result_prefix, 'db.sqlite']);

db = mksqlite('open', db_filename);

mksqlite('PRAGMA journal_mode=OFF');

%-- Tables creation

mksqlite('DROP TABLE IF EXISTS sos');
mksqlite(['CREATE TABLE IF NOT EXISTS sos '...
          '('...
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '...
          'subject TEXT, '...
          'dir_f0 REAL, '...
          'dir_ser REAL, '...
          'dir_voice TEXT, '...
          'vocoder INTEGER, '...
          'vocoder_name TEXT, '...
          'vocoder_descr TEXT, '...
          'vocoder_type TEXT, '...
          'TMR INTEGER, '...
          'words TEXT, '...
          'sentence TEXT, '...
          'nwords_total INTEGER, '...
          'nwords_correct INTEGER,'...
          'words_offline TEXT, '...
          'nwords_correct_offline INTEGER, '...
          'trial_start_datetime TEXT, '...
          'stimulus_start_datetime TEXT, '...
          'trial_duration_sec FLOAT, '...
          'i INTEGER'...
          ')']);
     
%-----------------------

%which_threshold = 'last_6_tp';
%which_threshold = 'all';

%-- Fill the tables
for i=1:length(files)
    
    disp(sprintf('=====> Processing %s...', files{i}));
    
    load(fullfile(options.result_path,files{i} ,files{i}));
    
    %phase = 'test';

    for ic=1:length(results)
        
        t = results(ic);

        r = struct();
        
        %remove the path and extract the subject name
        subj_name = strsplit(options.res_foldername, '/');
        subj_name = strsplit(subj_name{end},'_');
        subj_name = subj_name{end};
        

        r.subject = subj_name;

        %r.ref_f0 = options.voices(t.ref_voice).f0;
        r.dir_f0 = options.test.voices(t.dir_voice).f0;
        %r.ref_ser = options.voices(t.ref_voice).ser;
        r.dir_ser = options.test.voices(t.dir_voice).ser;
        %r.ref_voice = options.voices(t.ref_voice).label;
        r.dir_voice = options.test.voices(t.dir_voice).label;

        r.vocoder = t.vocoder;
        

        if r.vocoder > 0
            r.vocoder_name = options.vocoder(r.vocoder).label;
            r.vocoder_descr = options.vocoder(r.vocoder).description;
            
            type = options.vocoder(r.vocoder).parameters.analysis_filters.type;

            switch type
                case 'greenwood'
                    r.vocoder_type = 'GW';
                case 'lin'
                    r.vocoder_type = 'LIN';
                case 'ci24'
                    r.vocoder_type = 'CI';
                case 'hr90k'
                    r.vocoder_type = 'HR';
            end
            
        end
        r.TMR = t.TMR;
        
        if isempty(t.words)
            t.words = {''};
        end
        r.words = strjoin(t.words);
        r.sentence = t.sentence;
        
        nwords_total = strsplit(r.sentence,' ');
        r.nwords_total = length(nwords_total);
        
        r.nwords_correct = t.nwords_correct;
        if isempty(t.words_offline)
            t.words_offline = {''};
        end
        r.words_offline = strjoin(t.words_offline);
        r.nwords_correct_offline = t.nwords_correct_offline;

%         rewt = regexp(which_threshold, 'last_(\d+)_tp', 'tokens');
%         if isempty(rewt)
%             i_tp = a.diff_i_tp;    
%             r.threshold = a.threshold;
%         else
%             ntp = str2double(rewt{1});
%             i_nz = find(a.steps~=0);
%             i_d  = find(diff(sign(a.steps(i_nz)))~=0);
%             i_tp = i_nz(i_d)+1;
%             i_tp = [i_tp, length(a.differences)];
%             i_tp = i_tp(end-(ntp-1):end);
% 
%             r.threshold = mean(a.differences(i_tp));

%         u_f0  = 12*log2(options.(phase).voices(t.dir_voice).f0 / options.(phase).voices(t.ref_voice).f0);
%         u_ser = 12*log2(options.(phase).voices(t.dir_voice).ser / options.(phase).voices(t.ref_voice).ser);
%         u = [u_f0, u_ser];
%         u = u / sqrt(sum(u.^2));

        

        r.trial_start_datetime = datestr(t.trial_start_timestamp, 'yyyy-mm-dd HH:MM:SS');
        r.stimulus_start_datetime = datestr(t.stim_start_timestamp, 'yyyy-mm-dd HH:MM:SS');
        r.trial_duration_sec = t.trial_dur;
%         r.sd = a.sd;
         r.i = ic;

        mksqlite_insert(db, 'sos', r);
    %end
        
    end
end




mksqlite(db, 'close');

%rmpath('./mksqlite');

%==========================================================================
function md = md5(msg)

MD = java.security.MessageDigest.getInstance('md5');
md = typecast(MD.digest(uint8(msg)), 'uint8');
md = lower(reshape(dec2hex(md)', 1, []));

%==========================================================================
function md = md5_file(filename)

fid = fopen(filename, 'r');
md = md5(fread(fid));
fclose(fid);

