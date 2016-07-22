function [stim,fs] = vocodeStimulus(x,fs, options,voc)

        
    [stim, fs] = vocode(x, fs, options.vocoder(voc).parameters);          
    stim = stim(:);

    %This prevents the wavwrite from clipping the data
    m = max(abs(min(stim)),max(stim)) + 0.001;
    stim = stim./m;

end