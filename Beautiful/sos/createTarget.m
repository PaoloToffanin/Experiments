function [target,sentence,fs] = createTarget(options,condition,phase,varargin)

    switch phase
        case 'test'
            sentence = condition.test_sentence;
        case {'training1','training2'}
            sentence = condition.(phase).sentences(varargin{1});
    end
    
% N:    wavIn = fullfile(options.sound_path, [num2str(sentence), '.wav']);
    wavIn = [options.sound_path 'Vrouw' sprintf('%03d', sentence) '.wav'];
    if exist(wavIn, 'file')
        [target,fs] = audioread(wavIn);
    else
        fprintf('%s does not exists, skipping\n', wavIn);
        return
    end
    
    silence_gap_start = floor(0.5*fs); %500ms silence at the beginning of the target.
    silence_gap_end = floor(0.25*fs); %250ms silence at the end of the target.
    target = [zeros(silence_gap_start,1);target;zeros(silence_gap_end,1)]; %zero pad with silence gap of 500 ms at the beginning and 250 ms at the end.
    

end