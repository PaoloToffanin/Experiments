clear all

locationExp = '/Users/elifkaplan/Desktop/Experiments/Sentences/';
targets1Loc = 'Carina_Sent/';
targets2Loc = 'Jefta_Sent/'
maskersLoc = 'spraak/';

fs = 44100;

targets_C = dir([locationExp targets1Loc '*.wav'])

for i=1:length(targets_C)

[x, fs] = audioread([targets1Loc targets_C(i).name]);
silence = zeros(1,fs/2);

x = [silence x' silence];
target_C{i} = x;


end

maskers_V = dir([locationExp maskersLoc 'Vrouw*.wav'])

for j = 1:length(maskers_V)
    [x, fs] = audioread([maskersLoc maskers_V(j).name]);
    maskers_V_t{j} = x;
end

maskers_M = dir([locationExp maskersLoc 'Man*.wav'])

for k = 1:length(maskers_M)
    [z, fs] = audioread([maskersLoc maskers_M(k).name]);
    maskers_M_t{k} = z;
end


for i=1:95
length_t =   size(target_C{1,i});
length_t = length_t(2);
%new_length = zeros(1,length(target_C));
new_length{i} = length_t;
end

lengths_target = cell2mat(new_length);

% maskersM = cell2mat(cellfun(@cell2mat, maskers_M_t, 'UniformOutput', false));
%maskersM = reshape(maskersM,[1,

maskersAll_m = vertcat (maskers_M_t{:});
maskersAll_v = vertcat (maskers_V_t{:});
target_C = target_C';
target_C2 = horzcat(target_C{:}); 

% j=1;
% k = 142972;
% l=2;
% for i = 1:94
%    stimuli(i).trial = target_C2(j:k) + maskersAll_m(j:k)' + maskersAll_v(j:k)'; 
%    j = j + lengths_target(i);
%    k = k + lengths_target(l);
%    l=l+1;
% end

j=1;
k = 142972;
l=2;

% masker = masker./rmsM.*(rmsT/10^(trial.TMR/20));

targetRMS = rms(target_C2 (j:k));
tmr = 10;
male = maskersAll_m(j:k)' ./ rms(maskersAll_m(j:k)') .* (targetRMS/10^(tmr/20));
female = maskersAll_v(j:k)'./ rms(maskersAll_v(j:k)') .* (targetRMS/10^(tmr/20)) ;

% stimuli(i).trial = target_C2(j:k) + male + female; 

soundsc (target_C2(j:k) + male + female, fs)