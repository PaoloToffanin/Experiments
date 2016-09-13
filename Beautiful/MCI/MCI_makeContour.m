function [notes2play, fs] = MCI_makeContour(stimuli)
    
%         disp(istim)
%         istim = 200;
%         nNotes = length(stimuli(istim).mci);

%         [notes2play, fs] = mci_audioFile(stimuli(istim).instrument, stimuli(istim).mci);
        [notes2play, fs] = MCI_audioFile(stimuli.instrument, stimuli.mci);
        masker = zeros(size(notes2play));
%         if stimuli(istim).maskerInstrument
%             [masker, fs] = MCI_audioFile(stimuli(istim).maskerInstrument, stimuli(istim).maskerMci);
        if stimuli.maskerInstrument
            [masker, fs] = MCI_audioFile(stimuli.maskerInstrument, stimuli.maskerMci);
        end
        
        % mixing
        if length(notes2play) ~= length(masker)
            % check which is shorter and pad with zeros
            if length(notes2play) < length(masker)
                notes2play(end + 1 : length(masker)) = ...
                    zeros(length(masker) - length(notes2play), 1);
            else
                masker(end + 1 : length(notes2play)) = ...
                    zeros(length(notes2play) - length(masker), 1);
            end
%             plot(masker)
%             hold on
%             plot(notes2play, 'r')
        end
%        options.attenuation_dB = 0;
%         notes2play = (notes2play + masker) * 10^(-options.attenuation_dB/20);
% there is no attenuation
        notes2play = notes2play + masker;
% are the masker and target play concurrently/at the same time?
        
%         audiowrite([instruments{ins} '.wav'], notes2play, fs);
%         stimuli(istim).instrument
%         fs = 44100;
%         audiowrite(['/home/paolot/sounds/MCI/', ...
%             stimuli(istim).instrument stimuli(istim).mci(1) '_' , ...
%             stimuli(istim).mciProfile, ... 
%             stimuli(istim).instrument '_'  num2str(stimuli(istim).maskerStarts), ...
%             '.wav'], notes2play, fs);
%         p = audioplayer(notes2play, fs);
%         playblocking(p)
        

end % function melodicContour_v2