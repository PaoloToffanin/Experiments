function [expe, options] = sos_build_conditions(options)
% Creates the options and expe structs. Those contain all conditions and
% params that are needed for the experiment.
%


%% ----------- Voice options
i_voices = 1;

% We'll use this one for target. We don't use STRAIGHT because we don't
% change F0 and VTL on this one. This is mostly to save computing time.
switch options.targetSex
    case 'Vrouw'
        label = 'female';
    case 'Man'
        label = 'man';
end
options.test.voices(i_voices).label = label; 
options.test.voices(i_voices).f0 = NaN; % <- NaN means no STRAIGHT processing
options.test.voices(i_voices).vtl = NaN;
options.test.voices(i_voices).f0_ratio = NaN;
options.test.voices(i_voices).ser_ratio = NaN;
%options.test.voices(i_voices).filemask = 'Vrouw%03d.wav';
options.test.voices(i_voices).list_indices = 39:78;

i_voices = i_voices + 1;

% We'll use this is one as masker with no F0 and VTL difference.
options.test.voices(i_voices).label = [label '-STRAIGHT'];
options.test.voices(i_voices).f0 = 0;
options.test.voices(i_voices).vtl = 0;
options.test.voices(i_voices).f0_ratio = 1;
options.test.voices(i_voices).ser_ratio = 1; 
% filenames are coded as Vrouw001.wav or Man001.wav
options.test.voices(i_voices).filemask = [options.targetSex '%03d.wav'];

i_voices = i_voices + 1;

for i_f0 = 1:length(options.test.f0s)
    for i_vtl = 1:length(options.test.vtls)
        options.test.voices(i_voices).label = sprintf('f0=%.1fst, vtl=%.1fst', ...
            options.test.f0s(i_f0), options.test.vtls(i_vtl));
        options.test.voices(i_voices).f0 = options.test.f0s(i_f0);
        options.test.voices(i_voices).vtl = options.test.vtls(i_vtl);
        options.test.voices(i_voices).f0_ratio = 2^(options.test.f0s(i_f0)/12);
        options.test.voices(i_voices).ser_ratio = 2^(-options.test.vtls(i_vtl)/12);
        options.test.voices(i_voices).filemask = [options.targetSex '%03d.wav'];
        i_voices = i_voices + 1;
    end
end

% Voice pairs: [target_voice, masker_voice]
options.test.voice_pairs = [ones(length(options.test.voices)-1,1), ...
    (2:length(options.test.voices))'];

%---- Same thing for the training

options.training.f0s  = 8; % Semitones re. original
options.training.vtls = 8; % Semitones re. original

i_voices = 1;
options.training.voices(i_voices) = options.test.voices(1);
i_voices = i_voices + 1;
options.training.voices(i_voices) = options.test.voices(2);
i_voices = i_voices + 1;

for i_f0 = 1:length(options.training.f0s)
    for i_vtl = 1:length(options.training.vtls)
        options.training.voices(i_voices).label = sprintf('f0=%.1fst, vtl=%.1fst', ...
            options.training.f0s(i_f0), options.training.vtls(i_vtl));
        options.training.voices(i_voices).f0 = options.training.f0s(i_f0);
        options.training.voices(i_voices).vtl = options.training.vtls(i_vtl);
        options.training.voices(i_voices).f0_ratio = 2^(options.training.f0s(i_f0)/12);
        options.training.voices(i_voices).ser_ratio = 2^(-options.training.vtls(i_vtl)/12);
        options.training.voices(i_voices).filemask = [options.targetSex '%03d.wav'];
    end
end

% Voice pairs: [target_voice, masker_voice]
options.training.voice_pairs = [ones(length(options.training.voices)-1,1), ...
    (2:length(options.training.voices))'];

%------- Generate voice conditions from actual voices
%{
i_voices = 1;

options.test.voices(i_voices).label = 'female';
options.test.voices(i_voices).f0 = NaN;
options.test.voices(i_voices).vtl = NaN;
options.test.voices(i_voices).f0_ratio = NaN;
options.test.voices(i_voices).ser_ratio = NaN;
options.test.voices(i_voices).filemask = 'Vrouw%03d.wav';

i_voices = i_voices + 1;

options.test.voices(i_voices).label = 'male';
options.test.voices(i_voices).f0 = NaN;
options.test.voices(i_voices).vtl = NaN;
options.test.voices(i_voices).f0_ratio = NaN;
options.test.voices(i_voices).ser_ratio = NaN;
options.test.voices(i_voices).filemask = 'Man%03d.wav';

% Voice pairs: [target_voice, masker_voice]
options.test.voice_pairs = [1, 1; 1, 2];

% For training
options.training.voices = options.test.voices;
options.training.voice_pairs = options.test.voice_pairs;

%}

%% -------------------- TMRs

options.training.TMRs = 12; %dB
options.test.TMRs = 12; %[-8, -4, 0];

% If vocoded, this is a more appropriate range:
%options.test.TMRs = [0, 2, 6, 12];

% This protocol was adopted from Mike and Nikki's Musician effect on SOS
% performance; TMR values taken from Pals et al. 2015, and Stickney et al.
% 2004.



%% -------------------- Sentence bank
% We get the sentences that correspond to the corpus
% (see SOS_OPTIONS for the definition of options.sentences_file)

%----- This code is specific to the corpus, but must provide the following
%----- methods, variables
%
% The options.sentence_lists variable contains an array of indices that
% define lists of sentences: rows are sentence indices in the list, and
% columns define lists; zeros are placeholders.
%
% We then build a function or matrix options.sound_filename(index) that returns
% a sound filename from an index.
%
% Finally, we build an association between sound file name and sentence text, so
% that calling options.sentence(filename) returns the sentence.

% For the VU corpus, we read the sentence list which gives the sentences in
% the same order as the directory containing the wav files.



% options.sentences = readlines(options.sentences_file); % Assuming UTF-8 encoding

corpus = parseCorpus(options); % Assuming UTF-8 encoding

% no idea what this below is, get rid of it
% options.sentence_array = struct();
% wavfiles = dir(fullfile(options.sound_path, '*.wav')); % <- WE DON'T WANT THAT
% for i=1:length(wavfiles)
%     options.sentence_array.(serialize(wavfiles(i).name)) = options.sentences{i};
% end
% options.sentence = @(x) options.sentence_array.(serialize(x));
% 
options.sentence_lists = reshape(1:507, 13, []); % Rows: sentences, Columns: lists
% make vector with name of the files containing the sentences
% options.sound_filename = @(index, mask) sprintf(mask, i); % Will use the mask defined in the voice option set (see above)

options.training.target.sentence_lists = 14;
options.training.masker.sentence_lists = [13, 21, 39];
options.test.target.sentence_lists = 1:12;
options.test.masker.sentence_lists = [13, 21, 39];




%% -------------------- Definition of the vocoders

% options.vocoder = struct();

% To add vocoders, uncomment the bock below
%{
% Base parameters
p = struct();
p.envelope = struct();
p.envelope.method = 'low-pass';
p.envelope.rectify = 'half-wave';
p.envelope.order = 2; %4th order envelope

p.synth = struct();
p.synth.carrier = 'noise';
p.synth.filter_before = false;
p.synth.filter_after  = true;
p.synth.f0 = 1;

p.envelope.fc = 200;

vo = 3; % Butterworth filter order fixed to 12th order.
nc = 8; % 8 channels

range = [150 7000];
carriers = {'noise','sin'};

vi = 1; %vocoder index

for i = 1:length(carriers) %loop on the different carriers
    p.synth.carrier = carriers{i};
    
    p.analysis_filters  = estfilt_shift(nc, 'greenwood', options.fs, range, vo);
    p.synthesis_filters = estfilt_shift(nc, 'greenwood', options.fs, range, vo);

    options.vocoder(vi).label = sprintf('n-%dch-%dord', nc, 4*vo);
    options.vocoder(vi).description = sprintf('[%d] %s vocoder, type %s ,%i bands from %d to %d Hz, order %i, %i Hz envelope cutoff.',...
                                              vi, p.synth.carrier, 'greenwood', nc, range(1), range(2), 4*vo, p.envelope.fc);
    options.vocoder(vi).parameters = p;
    vi = vi +1;
end

%}



%% ========================================================================
%% ================= Build Experimental Conditions: =======================

rng('shuffle');

%--------------------------------------- Build training block
% training = struct();

%3. Define the training sentences:
training_list      = datasample(options.training.target.sentence_lists, 1); %Randomly select a list
nTrainings = 2;
training_sentences = datasample(options.sentence_lists(:,training_list), ...
    options.training.n_sentences * nTrainings, 'Replace', false); % Randomly select n*2 sentences from the list
% PT: NOTE: there are 2 types of training!!!!
% k = 1;

totSentences = options.training.n_sentences * nTrainings * length(options.training.TMRs);
trial = repmat(struct('target_voice', 0, ...
    'masker_voice', 0, ...
    'target_sentence_index', 0, ...
    'target_filename', '', ...
    'target_sentence', '', ...
    'TMR', 0, ...
    'feedback', 1, ...
    'done', 0), totSentences, 1);

for iSent = 1 : totSentences 
    for iTMR = 1 : length(options.training.TMRs)
    
%        trial = struct();
        idx = (iTMR - 1) * options.training.TMRs + iSent; % saves typing
%         fprintf('generating training trial %i of %i\n', idx, totSentences)
        trial(idx).target_voice = options.training.voice_pairs(1, 1);
        trial(idx).masker_voice = options.training.voice_pairs(1, 2);

        trial(idx).target_sentence_index = training_sentences(iSent);
%         trial(idx).target_filename = options.sound_filename(trial(idx).target_sentence_index);
%         trial(idx).target_sentence = options.sentence(trial(idx).target_filename);
        trial(idx).target_filename = corpus(trial(idx).target_sentence_index).wavfile;
        trial(idx).target_sentence = corpus(trial(idx).target_sentence_index).sentence;

        trial(idx).TMR = options.training.TMRs(iTMR);

%         trial(idx).feedback = 1;
%         trial(idx).done = 0;

%         training.trial(k) = trial;

%        k = k+1;
    end
end
clear idx
trial = trial(randperm(length(trial)));
[trial.training] = deal('training1');
[trial(totSentences/nTrainings + 1 : totSentences).training] = deal('training2');
training.trial = trial;
% assign first half trial to training 1 and second half to training 2

expe.training = training;




%--------------------------------------- Build test block

test = struct();
% test_list      = datasample(options.test.target.sentence_lists, 1); %Randomly select a list
test_list      = options.test.target.sentence_lists(randperm(length(options.test.target.sentence_lists))); %Randomly select a list
% E: test_sentences = datasample(options.sentence_lists(:, test_list), ...
%      options.test.n_sentences*2, 'Replace', false); % Randomly select n*2 sentences from the list
test_sentences = datasample(options.sentence_lists(:, test_list), ...
    options.test.n_sentences, 'Replace', false); % Randomly select n*2 sentences from the list
% Vocoders to be tested (here, all vocoders that are defined)
 
vocoder_indices = 0;
nVocoders = length(vocoder_indices);
if isfield(options, 'vocoder')
    vocoder_indices = [vocoder_indices, 1 : length(options.vocoder)];
    % We randomize the order of the vocoders
    % E: vocoder_indices = shuffle(vocoder_indices);
    nVocoders = length(vocoder_indices);
    vocoder_indices = vocoder_indices(randperm(nVocoders));
end

% We randomize the voice pairs
% E: voice_pair_indices = randperm(size(options.test.voices_pairs, 1));
voice_pair_indices = randperm(size(options.test.voice_pairs, 1));


% We randomize TMRs
% E: TMRs = shuffle(options.test.TMRs);
TMRs = options.test.TMRs(randperm(length(options.test.TMRs)));
nTMRs = length(TMRs);
% E:k = 1;
nSentences = length(test_sentences);
nPairs = length(voice_pair_indices);
trial = repmat(struct('target_voice', 0, ...
    'masker_voice', 0, ...
    'target_sentence_index', 0, ...
    'target_filename', '', ...
    'target_sentence', '', ...
    'TMR', 0, ...
    'feedback', 1, ...
    'done', 0), nVocoders * nPairs * nTMRs * nSentences, 1);
% E:for i_vocoder = vocoder_indices
% E:    for i_voice = voice_pair_indices
% E:        for TMR = TMRs
iLoop = 0;
for i_vocoder = 1 : nVocoders
% PT: what is this vocoder_indeces loop for?    
    for i_voice = 1 : nPairs
        for iTMR = 1 : nTMRs
            iLoop = iLoop + 1;
            if (iLoop > length(test_list))
                fprintf('too many conditions for lists available')
                return;
            end
            test_sentences = datasample(options.sentence_lists(:, test_list(iLoop)), ...
                options.test.n_sentences, 'Replace', false); % Randomly select n*2 sentences from the list
            for i_sentence = 1 : nSentences% <- NEEDS TO BE DEFINED
% E:                trial = struct();
% E:                trial.target_voice = options.test.voice_pairs(i_voice, 1);
% E:                trial.masker_voice = options.test.voice_pairs(i_voice, 2);
                itrial = (i_vocoder - 1) * (nSentences * nTMRs * nPairs) + ...
                    (i_voice - 1) * (nSentences *nTMRs) + ... 
                    ((iTMR - 1) * nSentences + i_sentence);
                trial(itrial).vocoderIndeces = i_vocoder; % PT added this since did not know E meaning
                trial(itrial).target_voice = options.test.voice_pairs(i_voice, 1);
                trial(itrial).masker_voice = options.test.voice_pairs(i_voice, 2);
                
% E:                trial.target_sentence_index = training_sentences(i);
                trial(itrial).target_sentence_index = test_sentences(i_sentence);
% E:                trial.target_filename = options.sound_filename(trial.target_sentence_index);
                trial(itrial).target_filename = corpus(trial(itrial).target_sentence_index).wavfile;
                
% E:                 trial.target_sentence = options.sentence(trial.target_filename);
                trial(itrial).target_sentence = corpus(trial(itrial).target_sentence_index).sentence;

% E:                trial.TMR = options.training.TMRs(i_TMR);
                trial(itrial).TMR = options.test.TMRs(iTMR);

% E:                trial.feedback = 1;
% E:                trial.done = 0;
                
% E:                training.trial(k) = trial;
            end % for i_sentence = 1:nSentences
        end % TMR = TMRs
    end % i_voice = voice_pair_indices
end % for i_vocoder = vocoder_indices


test.trial = trial(randperm(length(trial)));

% PT: no idea what this piece below is doing, they do look like the same
% looping variables of the loop before though
% for session = 1
%     
%     i_condition = 1; %count the number of conditions needed
%     
%     rnd_voice_pairs = randperm(size(options.test.voice_pairs, 1));
%     
%     rnd_voice_pairs = rnd_voice_pairs(rnd_voice_pairs ~= 1); %discard the 0 vtl- 0 F0 condition when testing with a fixed TMR
% 
% 
%     %1. Randomize Vocoders
%     RandVocs = 0; %0 to indicate the non-vocoded conditio
%     if isfield(options, 'vocoder')
%         RandVocInd = randperm(length(options.vocoder));
%         Vocs = 1:length(options.vocoder);
%         RandVocs = Vocs(RandVocInd);
%         [0 RandVocs] %0 to indicate the non-vocoded condition
%     end  
%     
%     %2. Randomize the test list order:
%     n_session = ['testS' num2str(session)];   
%     testList = options.(n_session); % what the hell is this?
% 
%     rand_testList = datasample(testList, length(testList), 'Replace', false); %shuffle the order of the test lists
%     
%     
%     for i_voc = RandVocs 
%         
%         %2. Randomize TMRs
%         RandunVocTMRind = randperm(length(options.unVocTMR));
%         RandunVocTMR = options.unVocTMR(RandunVocTMRind);
% 
%         RandVocTMRind = randperm(length(options.VocTMR));
%         RandVocTMR = options.VocTMR(RandVocTMRind);
% 
%         if i_voc == 0
%             RandTMR = RandunVocTMR;
%         else
%             RandTMR = RandVocTMR;
%         end
%         
%         for i_TMR = RandTMR
%             
%             ind_testList = rand_testList(i_condition);
%             test_sentences = options.list{ind_testList}(1):options.list{ind_testList}(2);
%             
%             %Randomize the test sentences within a list:
%             test_sentences = datasample(test_sentences,nSentences,'Replace',false);
%             
%             %3. Define the training sentences:
%             trainList = datasample(options.trainSentences,1); %Randomly select a list
%             trainseq = datasample(options.list{trainList}(1):options.list{trainList}(2),options.training.nsentences*2,'Replace',false); %Randomly select n*2 sentences from the list
%             
%             for i_sent = test_sentences
% 
%                 condition = struct();
% 
%                 condition.session = session;
%                 condition.vocoder = i_voc;
% 
%                 condition.TMR = i_TMR;
% 
%                 condition.test_sentence = i_sent;
%                 condition.test_list = ind_testList;
%                 
%                 condition.ref_voice = options.test.voice_pairs(1, 1);
% 
%                 condition.dir_voice = options.test.voice_pairs(1, 2);
% 
%                 condition.training1.sentences = [trainseq(1:options.training.nsentences)];
%                 condition.training2.sentences = [trainseq(options.training.nsentences+1:end)];
%                 condition.train_list = trainList;
% 
% 
%                 condition.done = 0;
% 
%                 condition.visual_feedback = 0;
% 
% 
%                 if ~isfield(test,'conditions')
%                     test.conditions = condition;
%                 else
%                     test.conditions(end+1) = condition;
%                 end
% 
%             end
%             
%             i_condition = i_condition+1; %increment the counter.
%             
%         end
%         
%         
%         for i_vp = rnd_voice_pairs
%                 
%             ind_testList = rand_testList(i_condition);
%             test_sentences = options.list{ind_testList}(1):options.list{ind_testList}(2);
%             
%             %Randomize the test sentences within a list:
%             test_sentences = datasample(test_sentences,nSentences,'Replace',false);
%             
%             %3. Define the training sentences:
%             trainList = datasample(options.trainSentences,1); %Randomly select a list
%             trainseq = datasample(options.list{trainList}(1):options.list{trainList}(2),options.training.nsentences*2,'Replace',false); %Randomly select n*2 sentences from the list
% 
%             for i_sent = test_sentences
% 
%                 condition = struct();
% 
%                 condition.session = session;
%                 condition.vocoder = i_voc;
% 
%                 condition.TMR = options.unVocTMR(2);
% 
%                 condition.test_sentence = i_sent;
%                 condition.test_list = ind_testList;
% 
%                 condition.ref_voice = options.test.voice_pairs(i_vp, 1);
% 
%                 condition.dir_voice = options.test.voice_pairs(i_vp, 2);
% 
%                 condition.training1.sentences = [trainseq(1:options.training.nsentences)];
%                 condition.training2.sentences = [trainseq(options.training.nsentences+1:end)];
%                 condition.train_list = trainList;
% 
% 
%                 condition.done = 0;
% 
%                 condition.visual_feedback = 0;
% 
% 
%                 if ~isfield(test,'conditions')
%                     test.conditions = condition;
%                 else
%                     test.conditions(end+1) = condition;
%                 end
% 
%             end
% 
%             i_condition = i_condition+1; %increment the counter.
%         end
%         
%     end
% end

%Randomize all:
%test.conditions = test.conditions(randperm(length(test.conditions)));
%====================================== Create the expe structure and save

expe.training = training;
expe.test = test;

%--
                
if isfield(options, 'result_path') && isfield(options, 'res_filename')
    save([options.result_path options.res_filename], 'options', 'expe');
else
    warning('The test file was not saved. Results directory not provided');
end




