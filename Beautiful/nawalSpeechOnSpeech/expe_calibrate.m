%calibrate Stille Kamer:

current_dir = fileparts(mfilename('fullpath'));
added_path  = {};

added_path{end+1} = '~/Library/Matlab/auditory-research-tools/vocoder_2015';
addpath(added_path{end});

added_path{end+1} = '~/Library/Matlab/auditory-research-tools/STRAIGHTV40_006b';
addpath(added_path{end});

added_path{end+1} = '~/Library/Matlab/auditory-research-tools/common_tools';
addpath(added_path{end});

[expe, options] = expe_build_conditions();

trial = expe.test.conditions(1);
trial.vocoder = 0;
trial.TMR = 0;
options.attenuation_dB = 6;

x = [];

for i = 1:15

    trial.test_sentence = i;
    [target,masker,sentence,fs] = expe_make_stim(options,trial,'test');
    xOut = target(floor(0.5*fs):end)*10^(-options.attenuation_dB/20);
    %xOut = (target+masker)*10^(-options.attenuation_dB/20);
    
    x = [x; xOut];
end

p = audioplayer(x,fs,16);
play(p);