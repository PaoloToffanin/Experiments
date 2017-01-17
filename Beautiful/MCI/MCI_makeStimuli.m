function [stimuli, nBlocks] = MCI_makeStimuli
% function [stimuli, nBlocks] = MCI_makeStimuli(phase)

% since there are repetitions of the same stimuli we actually do not need
% to generate the same stimuli three times... but this for later
    phases = {'training', 'test'};
    nphases = length(phases);
    for phase = 1 : nphases
        start = 57; % this is A3, A5 is 81
        semitonesSteps = [3, 4, 5];
        nSemitonesSteps = length(semitonesSteps);
        nNotes = 5;
        
        % contours = [rising, risingflat, risingfalling, flatrising, falling, flat, flatfalling, fallingrising, fallingflat, falling];
        % contours = ['rising', 'risingflat', 'risingfalling', 'flatrising', 'falling', 'flat', 'flatfalling', 'fallingrising', 'fallingflat', 'falling'];
        
        % organ first because it's easier
        instruments = {'O', 'P'};
        nInstruments = length(instruments);
        nRepetitions = 3;
        counter = 1;
        maskerStart = [0, 81, 57]; % masker starting at different semitone is
        % easier to distingush than masker starting at same semitone
        maskerInstrument = {'', 'P', 'P'};
        nMaskers = length(maskerStart);
        
        % restructure this so that we have a 486 items structures (put all the melodic contours into an array and loop through that as well)
%         for iMask = 1 : nMaskers
%             for instr = 1 : 1
%                 for isemi = 1 : 3
%                     for irep = 1 : 1
        for iMask = 1 : nMaskers
            for instr = 1 : nInstruments
                for isemi = 1 : nSemitonesSteps
                    for irep = 1 : nRepetitions
                        mci.rising = start : semitonesSteps(isemi) : (start + (semitonesSteps(isemi) * (nNotes-1)));
                        mci.risingflat = [start : semitonesSteps(isemi) : (start + (semitonesSteps(isemi) * (nNotes-3))), ...
                            start + (semitonesSteps(isemi) * (nNotes-3)) start + (semitonesSteps(isemi) * (nNotes-3))];
                        mci.risingfalling = [start : semitonesSteps(isemi) : (start + (semitonesSteps(isemi) * (nNotes-3))), ...
                            start + (semitonesSteps(isemi)) : -semitonesSteps(isemi) : start];
                        mci.flatrising = [start, start, start : semitonesSteps(isemi) : (start + (semitonesSteps(isemi) * (nNotes-3)))];
                        mci.flat = repmat(start, length(isemi), 5);
                        mci.flatfalling = [repmat((start + (semitonesSteps(isemi) * (nNotes-3))), 1, 2), ...
                            start + (semitonesSteps(isemi) * (nNotes-3)) : -semitonesSteps(isemi) : start];
                        mci.fallingrising = [start + (semitonesSteps(isemi) * (nNotes-3)): -semitonesSteps(isemi) : start, ...
                            start + (semitonesSteps(isemi)), start + (semitonesSteps(isemi) * 2)];
                        mci.fallingflat = [start + (semitonesSteps(isemi) * (nNotes-3)): -semitonesSteps(isemi) : start, repmat(start, 1, 2)];
                        mci.falling = (start + (semitonesSteps(isemi) * (nNotes-1))) : -semitonesSteps(isemi) : start;
                        contour2play = fieldnames(mci);
                        nContours = length(contour2play);
                        for icontour = 1 : nContours
%                         for icontour = 1 : 1
                            stimuli(counter).instrument = instruments{instr};
                            stimuli(counter).mci = mci.(contour2play{icontour});
                            stimuli(counter).targetStarts = stimuli(counter).mci(1);
                            %                         stimuli(counter).mciLabel = contour2play{icontour};
                            stimuli(counter).mciProfile = contour2play{icontour};
                            stimuli(counter).maskerInstrument = maskerInstrument{iMask};
                            stimuli(counter).maskerStarts = maskerStart(iMask);
                            stimuli(counter).maskerMci = repmat(maskerStart(iMask), length(isemi), 5); % mci.flat;
                            stimuli(counter).response = '';
                            stimuli(counter).acc = 0;
                            stimuli(counter).done = 0;
                            counter = counter + 1;
                        end
                    end
                end
            end
        end
        % folderInstruments = {'piano', 'organ'};
        % Masker = ['A3', 'A5']
        
        masker = [57, 81]; % this is always flat and it is alwasy the piano.
        
%% randomize order
        %     stimuli = stimuli(randperm(length(stimuli)));
        % this is not necessary now...
        % training or test?
        nTrialsPerBlock = nContours * nRepetitions;
        nBlocks(phase) = length(stimuli) / nTrialsPerBlock;
        switch phases{phase}
            case 'training'
                trainingSet = [];
                for isemi = 1 : nSemitonesSteps
                    trainingSet = [trainingSet,  [1:9] + 9 * nSemitonesSteps * (isemi - 1)];
                end
                trainingSet = trainingSet(randperm(length(trainingSet)));
                trainingSet2 = [];
                maskerStartsAt = nInstruments * nSemitonesSteps * nRepetitions * nContours; % #instruments, #semitones, #reps, #contours, #starts at level 81
                for isemi = 1 : nSemitonesSteps
                    trainingSet2 = [trainingSet2,  maskerStartsAt + [1:nContours] + nContours*nSemitonesSteps * (isemi - 1)];
                end
                trainingSet2 = trainingSet2(randperm(length(trainingSet2)));
                trainingSet = [trainingSet, trainingSet2];
                stimuli = stimuli(trainingSet);
                nBlocks = 2; % for now the nBlocks for the training phase is
                % hardcoded to be 54/2 (27 also in the test session). 
                [stimuli.phase] = deal(phases{phase});
%                 tmp = stimuli;
                trainingStimuli = stimuli;
            case 'test'
                % randomize every 27 trials so that we keep blocks of contours
                % per repetition
                for iblocks = 1 : nBlocks
                    stimuli([1 : nTrialsPerBlock] + nTrialsPerBlock * (iblocks - 1)) = ...
                        stimuli(randperm(nTrialsPerBlock) + nTrialsPerBlock * (iblocks - 1));
                end
                [stimuli.phase] = deal(phases{phase});
%                 tmp(end+1 : end + length(stimuli)) = stimuli;
                testStimuli = stimuli;
            otherwise
                error('Error. \nUnknown phase option %s', phases{phase})
        end % switch phase
    end % for loop phases
%     stimuli = tmp;
    stimuli = [trainingStimuli, testStimuli];
    
end % end function