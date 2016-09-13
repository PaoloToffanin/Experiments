function [masker,target,fs,masker_struct] = createMasker(options,condition,phase,target,fs,varargin)
 
   %Take random pieces of masker sentences and stitch them together.
    %Target and masker should be the same length to be added later.  

    sentence_bank = [];
    for i_masker_list = 1 : length(options.masker)
        
        masker_list = options.masker(i_masker_list);
        masker_sentences = options.list{masker_list}(1) : options.list{masker_list}(2);
        sentence_bank = [sentence_bank masker_sentences];

    end
    
    
    %Randomize sentences:
    
    masker_struct = struct();
    masker = [];
    n_chunk = 1;
    
    while length(masker) < length(target)
        %Pick a random sentence from the masker sentence_bank:
        i = datasample(sentence_bank,1);
        masker_struct(n_chunk).sentence_nr = i;
% N:        masker_struct(n_chunk).sentence = sentence_bank{i};
        masker_struct(n_chunk).sentence = sentence_bank(sentence_bank == i);
        
        f0 = options.(phase).voices(condition.dir_voice).f0;
        ser = options.(phase).voices(condition.dir_voice).ser;
% N:         filename = make_fname([num2str(i) '.wav'], f0, ser, options.tmp_path);
%         filename = make_fname([options.maskerSex num2str(i) '.wav'], f0, ser, options.tmp_path);
%         filename = [options.tmp_path 'M_' options.maskerSex num2str(i) ...
        filename = [options.tmp_path 'M_' condition.maskerVoice num2str(i) ...
            sprintf('_GPR%.2f_SER%.2f', f0, ser) '.wav'];
        % load file if it exists
        if exist(filename,'file')
            [y,fs] = audioread(filename);
        else
            % ask whether to generate them on the file or to run the script
            % which creates them. Which is? 
            fprintf(['maskers do not exists!\n',...
                'run sos_createMaskers(options)!\n',...
                'terminating now!\n']);
            return;
        end
        %Take chunk sizes that are at least 1 sec long
        min_dur = 1; %1 sec
        max_dur = floor(length(y)/fs); %length of the whole sentence.
        r = round((max_dur-min_dur).*rand(1,1) + min_dur); % N: round instead 
        % of floor otherwise it always takes the same chunck.
        chunk_size = r*fs; %take chunk sizes of min 1 sec from each sentence
        
        
        %start the chunk at a random location in the file: 
        chunk_start = randperm(length(y),1);
        
        if chunk_start+chunk_size > length(y)
            if chunk_start-chunk_size < length(y)
                chunk_ind = [1 chunk_size];
            else
                chunk_ind = [chunk_start-chunk_size chunk_start];
            end
        
        else
            chunk_ind = [chunk_start chunk_start+chunk_size];
        end
        
        chunk = y(chunk_ind(1):chunk_ind(2));
        
        %Apply cosine ramp:
        chunk = cosgate(chunk, fs, 2e-3); %2ms cosine ramp.
        
        masker = [masker; chunk];
        
        masker_struct(n_chunk).chunk_start = chunk_ind(1);
        masker_struct(n_chunk).chunk_end = chunk_ind(2);
        
        n_chunk = n_chunk+1;
        %!!!! RETURN SENTENCE NUMBER, INDEX_START OF CHUNK, INDEX_END OF
        %CHUNK => PUT THEM IN A STRUCT ARRAY TO HAVE EACH CHUNK DESCRIBED
        %AND THE STRUCT SHOULD BE ADDED TO RESULTS STRUCT
        
        
    end
    
    
%   Set lenght of masker vector = length of target vector. This makes sure
%   that only the vectors are of equal length so that we could add them.
%   However, length of the masker SIGNAL (actual speech) and target SIGNAL
%   are NOT the same:
    if length(masker) >= length(target)
      
        masker = masker(1:length(target)); %chop it off if it is too long
        
    end
    
    masker = cosgate(masker, fs, 50e-3); %50ms cosine ramp to both beginning and end of masker signal.
    
    %Set masker RMS:
    rmsM = rms(masker);
    silence_start = floor(0.5*fs);
    silence_end = length(target)-floor(0.25*fs);
    rmsT = rms(target(silence_start:silence_end));
    masker = masker./rmsM.*(rmsT/10^(condition.TMR/20));
    

end
