function [expe, options] = building_conditions(options)
%	Design specification


    options.test.n_repeat = 4; % Number of repetition per condition
    options.test.retry = 1; % Number of retry if measure failed
    
    options.facerecognition.n_repeat = 2;
    options.facerecognition.retry = 0 ; 
    options.facerecognition.total_ntrials = 6; 

    % -------- Stimuli options 
    options.facerecognition.faces = {'angry1', 'sad1', 'joyful1','angry2', 'sad2', 'joyful2'}; % PT: we need to distinguish the faces
    options.test.voices = {'angry', 'sad', 'joyful'};
    options.test.faces = {'angry', 'sad', 'joyful'};


    %--- stimuli pairs % [voice, face]
    options.test.stimuli_pairs = [...
        1 1;  % angry - angry
        1 2;  % angry - sad
        1 3;  % angry - joyful
        2 1;  % sad - angry
        2 2;  % sad - sad
        2 3;  % sad - joyful
        3 1;  % joyful - angry
        3 2;  % joyful - sad
        3 3;];  % joyful - joyful

    %====================== Build test block

    % we have a 1 to 2 ratio for compatibility. We want to keep that 1:1, so
    % we are going to exclude half of the incompatible trials. We could do that 
    % either having only 4 repetitions of the incongruent images or selecting
    % them afterwards. 

    itrial = 0;
    npairs = length(options.test.stimuli_pairs);
    halfRep = options.test.n_repeat / 2;
    
    for irep = 1 : options.test.n_repeat
        for ipair = 1 : npairs
            if irep > halfRep
                voice = options.test.stimuli_pairs(ipair, 1);
                face = options.test.stimuli_pairs(ipair, 2);
                if voice == face
                    itrial = itrial + 1;
                    condition(itrial).voice = options.test.stimuli_pairs(ipair, 1);
                    condition(itrial).face = options.test.stimuli_pairs(ipair, 2);
                    condition(itrial).voicelabel = options.test.voices{options.test.stimuli_pairs(ipair, 1)};
                    condition(itrial).facelabel = options.test.faces{options.test.stimuli_pairs(ipair, 2)};
                    condition(itrial).congruent = condition(itrial).voice == condition(itrial).face;
                end

            else
                itrial = itrial + 1;
                condition(itrial).voice = options.test.stimuli_pairs(ipair, 1);
                condition(itrial).face = options.test.stimuli_pairs(ipair, 2);
                condition(itrial).voicelabel = options.test.voices{options.test.stimuli_pairs(ipair, 1)};
                condition(itrial).facelabel = options.test.faces{options.test.stimuli_pairs(ipair, 2)};
                condition(itrial).congruent = condition(itrial).voice == condition(itrial).face;
            end
        end
    end
    
    options.test.total_ntrials = length(condition);
    test.condition = condition(randperm(options.test.total_ntrials));
    
    
%     nSplashes = 3;
    [test.condition.splash] = deal(0);
%     [test.condition(options.test.total_ntrials / nSplashes : options.test.total_ntrials / nSplashes : options.test.total_ntrials).splash] = deal(1);
    [test.condition.clownladderNmove] = deal(0);
    trialSeq = [3,4,5];
    nRep = options.test.total_ntrials / sum(trialSeq);
    trialSeq = repmat(trialSeq, 1, nRep);
    nSteps = [2 4 2];
    nRep = options.test.total_ntrials / sum(nSteps);
    nStep = repmat(nSteps, 1, nRep);
%     indexSeq = zeros(1, length(trialSeq));
    for iSeq = 1 : length(trialSeq)
%         indexSeq(iSeq) = sum(trialSeq(1:iSeq))
%         condition(sum(trialSeq(1:iSeq))).clownladderNmove = trialSeq(iSeq);
        test.condition(sum(trialSeq(1:iSeq))).clownladderNmove = nStep(iSeq);
        if trialSeq(iSeq) == 5
            test.condition(sum(trialSeq(1:iSeq))).splash = 1;
        end
    end
    
    % training.condition = condition(randperm(options.training.total_ntrials));
    options.training.total_ntrials = 9; 
    % find congruent trials
    idxTr = 1 : options.test.total_ntrials;
    congTr = idxTr([test.condition.congruent] == 1);
    congTr = randperm(length(congTr));
    % find incongruent trials
    incoTr = idxTr([test.condition.congruent] == 0);
    incoTr = randperm(length(incoTr));
    % make vector with 4 random congruent and 5 random incongruent trial
    nCongr = 4;
    nIncon = 5;
    training.condition = test.condition([congTr(1:nCongr), incoTr(1:nIncon)]);
    
    
    options.facerecognition.faces = options.facerecognition.faces(randperm(options.facerecognition.total_ntrials));
    
    %======== Create the expe structure 

    expe.test = test;
    expe.training = training;
    expe.facerecognition = options.facerecognition;

    %-- save: NO!! this overwrite stuff all time!!!

%     if isfield(options, 'res_filename')
%         save(options.res_filename, 'options', 'expe');
%     else
%         warning('The test file was not saved: no filename provided.');
%     end

end
