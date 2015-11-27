function [expe, options] = gender_buildingconditions(options)

    %----------- Signal options
    options.fs = 44100;
    if is_test_machine
        options.attenuation_dB = 3;  % General attenuation
    else
        options.attenuation_dB = 27; % General attenuation
    end
    options.ear = 'both'; % right, left or both

    %----------- Design specification
    options.test.n_repeat = 1; % Number of repetition per condition
    options.test.retry = 1; % Number of retry if measure failed
    

    %  training
    %  added training, maybe for young kids good to see if they understand

    % -------- Stimuli options
    if options.Bert
        options.test.f0s = [0 -3 -6 -9 -12]; % adults version
        options.test.vtls = [0 .7 1.6 2.4 3 3.6]; % adults version
    else
        options.test.f0s = [0 -6 -12]; % kids version
        options.test.vtls = [0 1.8 3.6]; % kids version
    end
    nF0 = length(options.test.f0s);
    
    nVtls = length(options.test.vtls);
    


    % PT: these were too many...
%     dir_waves = dir([options.sound_path, '/*.wav']);
%     word_list = {dir_waves.name}; % PT: two words are going to be removed from the set
%     nWords = length(word_list);
%     for word = 1 : nWords
%         options.words{word} = strrep(word_list{word}, '.wav', '');
%     end
    
     if strcmp(options.stage, 'generation')
         word_list = {'Bus', 'Leeg', 'Pen', 'Vaak'};% we are not using englihs stimuli anymore - I also don't really have them, 'bike', 'hat', 'pool', 'shoe', 'space', 'watch'};
     else
        switch options.language
%             case 'Dutch'
            case 'dutch'
                word_list = {'Bus', 'Leeg', 'Pen', 'Vaak'};
%             case 'English'
            case 'english'
                word_list = {'bike', 'hat', 'pool', 'watch'};
        end
     end
     
%     end
    nWords = length(word_list);
    
    % options.n_wrd = 4;
    options.test.total_ntrials = nWords * nVtls * nF0;
    oneSampleFile = [options.tmp_path word_list{1} ...
        sprintf('_GPR%d_VTL%.2f', options.test.f0s(1), options.test.vtls(1)) '.wav'];
    if exist(oneSampleFile, 'file')
        fileinfo = audioinfo(oneSampleFile);  
        options.word_duration = fileinfo.Duration;
    else
        options.word_duration = 850e-3; % PT this is just measured looking 
        % at the lenght of the word bus without silence in the current dataset
    end
    options.lowpass = 4000;
    options.force_rebuild_sylls = 0;

    % ==================================================== Build test block

    options.test.faces = {'woman_1','woman_2','woman_3','woman_4','woman_5','woman_6','woman_7', ...
      'man_1','man_2','man_3','man_4','man_5','man_6','man_7'};
    nFaces = length(options.test.faces);
    nRepetitions = ceil(options.test.total_ntrials/nFaces);
    nFemales = sum(strncmp(options.test.faces, 'woman', 5));
    nMales = nFaces - nFemales;
    indexes = repmat([1:nFemales], 1, nRepetitions);
    indexes = indexes(randperm(length(indexes)));
    indexes(options.test.total_ntrials/2 + 1 : end) = [];
    indexesM = repmat([(1:nMales) + nFemales], 1, nRepetitions);
    indexesM = indexesM(randperm(length(indexesM)));
    indexesM(options.test.total_ntrials/2 + 1 : end) = [];
    indexes = [indexes indexesM];
    indexes = indexes(randperm(length(indexes)));
    options.test.faces = options.test.faces(indexes);
    
    options.test.hands = {'handbang_', 'handremote_'}; % + 'handknob_%d';
    indexing = repmat ([1:length(options.test.hands)], 1, ...
        length(indexes)/length(options.test.hands));
    indexing = indexing (randperm(length(indexes)));
    options.test.hands = options.test.hands(indexing);
    
    test = struct();

    counter = 1;
    for ir = 1 : options.test.n_repeat
        for f0 = 1 : nF0 % length(options.test.f0s)
            for vtl = 1 : nVtls% length(options.test.vtls)
                for word = 1 : nWords
                    trial = struct();
                    trial.f0 = options.test.f0s(f0);
                    trial.vtl = options.test.vtls(vtl);
%                     trial.word = options.words{word};
                    trial.word = word_list{word};
                    trial.i_repeat = ir;
                    trial.done = 0;
                    trial.face = options.test.faces{counter};
                    trial.hands = options.test.hands{counter};
                    if ~isfield(test,'trials')
                        test.trials = orderfields(trial);
                    else
                        test.trials(end+1) = orderfields(trial);
                    end
                    counter = counter + 1;
                end
            end
        end
    end
    % test.condition = condition(randperm(length(condition)));

    % ====================================== Create the expe structure and save

    % don't randomize if stimuli are just generated
     if strcmp(options.stage, 'generation')
         expe.test.trials = test.trials;
     else
        expe.test.trials = test.trials(randperm(length(test.trials)));
     end
    
    if isfield(options, 'res_filename')
        save(options.res_filename, 'options', 'expe');
    else
        warning('The test file was not saved: no filename provided.');
    end
end

