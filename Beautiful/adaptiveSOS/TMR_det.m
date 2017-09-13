% todo:
% target has silence 500 ms before and after
% masker: concatenate masker sentences until the length is the same of the target
% put in the nva interface but with sentences instead of words

locationVU = '/Users/elifkaplan/Desktop/Experiments/Sentences/spraak/';
load ([locationVU 'VU_zinnen.mat']);
fs = 44100;
%% delete sentences from text list
nStims = length(VU_zinnen);
stim = repmat(struct('words', '', 'sex', ''), 1, nStims);
for item = 1 : nStims
    stim(item).words = VU_zinnen{item};
    stim(item).sex = 1; 
    limitMaleFemale = 507;
    dutchSex = 'Man';
    if item > limitMaleFemale
        stim(item).sex = 2;
        dutchSex = 'Vrouw';
    end
    
    stim(item).file = sprintf('%s%03i.wav', dutchSex, item ...
        - (limitMaleFemale * (stim(item).sex - 1)));

end
%%
sex = {'Man', 'Vrouw'}
posNumbers = [[4:6]; [6:8]];
trialsIn = [];
for isex = 1: length(sex)
    files = dir([locationVU sex{isex} '*.wav']);
    nfiles = length(files);
    for ifile = 1 : nfiles
        trialsIn = [trialsIn, str2double(files(ifile).name(posNumbers(isex, :))) + (isex - 1) * limitMaleFemale]; 
    end
end

stim = stim(trialsIn);
% target = 60 males (1) + 60 females (2)
nTargets = 60;
targetSel =[];
nSex = 2;
for isex = 1 : nSex
    targets = find([stim.sex] == isex);
    targets = targets(randperm(length(targets)));
    targetSel = [targetSel targets(1:nTargets)]; % check out how to set the random generator to be random everytime
end

targetSent = stim(targetSel);
maskersPool = stim;
maskersPool(targetSel) = [];

ntrials = length(targetSel);
ntrials = 1;
for trial = 1 : ntrials
    targetRMS = rms(audioread([locationVU targetSent(trial).file]));
    tmr = 10;
    [y, fs] = audioread([locationVU targetSent(trial).file]);
    silence = zeros(1,fs/2);
    
    
    male = maskersAll_m(j:k)' ./ rms(maskersAll_m(j:k)') .* (targetRMS/10^(tmr/20));
    female = maskersAll_v(j:k)'./ rms(maskersAll_v(j:k)') .* (targetRMS/10^(tmr/20)) ;
    target_C2(j:k) + male + female, fs
    p = audioplayer(y, fs);
    play(p);
end



