function [target,masker,sentence,fs,masker_struct] = sos_make_stim(options, condition, phase, varargin)
% function [target,masker,sentence,fs,masker_struct] = sos_make_stim(options, condition, phase, varargin)

    %phase needs to switch between training 1 (no masker), training 2 (masker)
    %and test. This parameter is set in expe_main.
    
    switch phase
        case 'training1'
            [target,sentence,fs] = createTarget(options,condition,phase,varargin{1});
            masker = zeros(length(target),1);
            masker_struct = [];
        case 'training2'
            [target,sentence,fs] = createTarget(options,condition,phase,varargin{1});
            [masker,target,fs,masker_struct] = createMasker(options,condition,'training',target,fs,varargin{1});
%             sos_createMaskers(options);
        case 'test'
            [target,sentence,fs] = createTarget(options,condition,phase);
            [masker,target,fs,masker_struct] = createMasker(options,condition,phase,target,fs);
%             sos_createMaskers(options);
    end
    
    
end







