
phase = 'training';
[stimuli, nBlocks] = MCI_makeStimuli(phase);
tstart = tic;
for istim = 1 : length(stimuli)

    [notes2play, fs] = MCI_makeContour(stimuli(istim));
    p = audioplayer(notes2play, fs);
    playblocking(p);
    telapsed = toc(tstart);
    if telapsed > 90
        break
    end
    
end
        
        