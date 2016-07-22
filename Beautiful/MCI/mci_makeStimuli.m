function stimuli = mci_makeStimuli


% since there are repetitions of the same stimuli we actually do not need
% to generate the same stimuli three times... but this for later

    start = 57; % this is A3, A5 is 81
    semitonesSteps = [3, 4, 5];
    nSemitonesSteps = length(semitonesSteps);
    nNotes = 5;

    % contours = [rising, risingflat, risingfalling, flatrising, falling, flat, flatfalling, fallingrising, fallingflat, falling];
    % contours = ['rising', 'risingflat', 'risingfalling', 'flatrising', 'falling', 'flat', 'flatfalling', 'fallingrising', 'fallingflat', 'falling'];
    instruments = {'P','O'};
    nInstruments = length(instruments);
    nRepetitions = 3;
    counter = 1;
    maskerStart = [0, 57, 81];
    markerInstrument = {'', 'P', 'P'};
    nMaskers = length(maskerStart);

    % resturcture this so that we have a 486 items structures (put all the melodic contours into an array and loop through that as well)
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
                        stimuli(counter).instrument = instruments{instr};
                        stimuli(counter).mci = mci.(contour2play{icontour});
%                         stimuli(counter).mciLabel = contour2play{icontour}; 
                        stimuli(counter).mciProfile = contour2play{icontour}; 
                        stimuli(counter).maskerInstrument = markerInstrument{iMask};
                        stimuli(counter).maskerStarts = maskerStart(iMask);
                        stimuli(counter).maskerMci = repmat(maskerStart(iMask), length(isemi), 5); % mci.flat;
                        stimuli(counter).response = '';
                        stimuli(counter).acc = 0;
                        counter = counter + 1;
                    end
                end
            end
        end
    end
    % folderInstruments = {'piano', 'organ'};
    % Masker = ['A3', 'A5']

    masker = [57, 81]; % this is always flat and it is alwasy the piano.

    % randomize order
%     stimuli = stimuli(randperm(length(stimuli)));
% this is not necessary now... 

end