function [notes2play, fs] = MCI_audioFile(instrument, mci)

    locationNotes = 'H:\data\Post-doc\Tests\\piano';
    locationNotes = '/home/paolot/gitStuff/emotionTaskAngelSound/Gronigen/Stimuli/MCI/';
    locationNotes = '~/Sounds/MCI/';

    notes2play = [];
    nNotes = length(mci);
    for inote = 1 : nNotes
        filename = [instrument sprintf('%03i', mci(inote)) '.WAV'];
        [y, fs] = audioread([locationNotes filename]);
        duration = 0.250;                % duration in seconds
        gatedur = .01;
        gate = cos(linspace(pi, 2*pi, fs*gatedur));
        gate = gate + 1;
        gate = gate/2;
        offsetgate = fliplr(gate);
        sustain = ones(1, (length(y)-2*length(gate)));
        envelope = [gate, sustain, offsetgate];
        rampedsignal = envelope .* y';
        notes2play = [notes2play; rampedsignal'; zeros(round(0.05 * fs), 1)];
    end
end            
