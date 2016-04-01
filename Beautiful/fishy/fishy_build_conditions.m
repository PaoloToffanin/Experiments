function [expe, options] = fishy_build_conditions(options)



options.instructions.training = ['You are going to hear three triplets of different syllables.\nOne of the triplets is said with a different voice.\n'...
    'Your task is to click on the button that corresponds to the different voice.\n\n'...
    '-------------------------------------------------\n\n'...
    ''];

options.instructions.test = options.instructions.training;

%----------- Signal options
options.fs = 44100;

%     options.attenuation_dB = 3;  % General attenuation
    options.attenuation_dB = 17; % General attenuation
if options.Bert
    options.attenuation_dB = 3; 
end

options.ear = 'both'; % right, left or both

if options.Bert
    options.ear = 'left'; 
end

%----------- Design specification
options.test.n_repeat = 1; % Number of repetition per condition
options.test.step_size_modifier = 1/sqrt(2);
options.test.change_step_size_condition = 2; % When difference leq than this times step-size, decrease step-size
options.test.change_step_size_n_trials = 15; % Change step-size every...
options.test.initial_step_size  = 2; % Semitones
options.test.starting_difference = 12; % Semitones
options.test.down_up = [2, 1]; % 2-down, 1-up => 70.7%
options.test.terminate_on_nturns = 8;
options.test.terminate_on_ntrials = 100; % PT, changed to 100, was 150
options.test.retry = 1; % Number of retry if measure failed
options.test.threshold_on_last_n_trials = 6;

options.training.n_repeat = 1;
% options.training.step_size_modifier = 1/sqrt(2);
options.training.step_size_modifier = 1; % PT: speed up the adaptive procedure
options.training.change_step_size_condition = 1; % PT: speed up the adaptive procedure% When difference <= this, decrease step-size
options.training.change_step_size_n_trials = 15; % Change step-size every...
options.training.initial_step_size  = 3;% PT: speed up the adaptive procedure% Semitones
options.training.starting_difference = 6;% PT: speed up the adaptive procedure % Semitones
options.training.down_up = [2, 1]; % 2-down, 1-up => 70.7%
options.training.terminate_on_nturns = 0; % PT uncomment because setUpGame uses this value
options.training.terminate_on_ntrials = 3;
options.training.retry = 0; % Number of retry if measure failed
% options.training.threshold_on_last_n_trials = 6;

%----------- Stimuli options
options.test.f0s  = [242, 121, round(242*2^(5/12))]; % 242 = average pitch of original female voice
options.test.sers = [1, 2^(-3.8/12), 2^(5/12)];

options.test.voices(1).label = 'female';
options.test.voices(1).f0 = 242;
options.test.voices(1).ser = 1;

options.test.voices(2).label = 'male';
options.test.voices(2).f0 = 121;
options.test.voices(2).ser = 2^(-3.8/12);

options.test.voices(3).label = 'child';
options.test.voices(3).f0 = round(242*2^(5/12));
options.test.voices(3).ser = 2^(7/12);

options.test.voices(4).label = 'male-gpr';
options.test.voices(4).f0 = 121;
options.test.voices(4).ser = 1;

options.test.voices(5).label = 'male-vtl';
options.test.voices(5).f0 = options.test.voices(1).f0;
options.test.voices(5).ser = 2^(-3.8/12);

options.test.voices(6).label = 'child-gpr';
options.test.voices(6).f0 = round(242*2^(5/12));
options.test.voices(6).ser = 1;

options.test.voices(7).label = 'child-vtl';
options.test.voices(7).f0 = options.test.voices(1).f0;
options.test.voices(7).ser = 2^(7/12);

options.training.voices = options.test.voices;

%--- Voice pairs
% [ref_voice, dir_voice]
options.test.voice_pairs = [...
%     1 2;  % Female -> Male
    1 4;  % Female -> Male GPR % only these two
    1 5;  % Female -> Male VTL % only these two
%     1 3;  % Female -> Child
%     1 6;  % Female -> Child GPR
%     1 7;  % Female -> Child VTL
%     2 1;  % Male   -> Female
%     2 4;  % Male   -> Male GPR (is Female VTL)
%     2 5;  % Male   -> Male VTL (is Female GPR)
%     3 1;  % Child  -> Female
%     3 6;  % Child  -> Child GPR (is Female VTL)
%     3 7; % Child  -> Child VTL (is Female GPR)

];

options.training.voice_pairs = [...
    1 5;  % Female -> Male VTL
    1 4]; % Female -> Male GPR

options.sound_path = [options.home '/sounds/' options.language '_CV/equalized/'];
options.tmp_path   = [options.home '/sounds/' options.language '_CV/processed/'];

if ~exist(options.sound_path, 'dir')
    error([options.sound_path ' does not exists']); 
end
if isempty(dir([options.sound_path '*.wav']))
    error([options.sound_path ' does not contain any sound files']); 
end
if ~exist(options.tmp_path, 'dir')
    % prevent paolo's computer to get full of rubbish straight processed
    % files
    if strcmp(java.net.InetAddress.getLocalHost.getHostName, 'debianENT')
        options.tmp_path   = ['/mnt/disk2/processedSounds/' options.language '_CV/'];
    else
        mkdir(options.tmp_path);
    end 
end

dir_waves = dir([options.sound_path, '/*.wav']);
syllable_list = {dir_waves.name};
for i= 1:length(syllable_list)
    syllable_list{i} = strrep(syllable_list{i}, '.wav', '');
end

options.syllables = syllable_list;
options.n_syll = 3;

options.inter_syllable_silence = 50e-3;
options.syllable_duration = 200e-3;

options.f0_contour_step_size = 1/3; % semitones
options.f0_contours = [[-1 0 +1]; [+1 0 -1]; [-1 1 -1]+1/3; [1 -1 1]-1/3; [-1 -1 1]+1/3; [1 1 -1]-1/3; [-1 1 1]-1/3; [1 -1 -1]+1/3];

options.inter_triplet_interval = 250e-3;

options.force_rebuild_sylls = 0;


%==================================================== Build test block

test = struct();

for ir = 1:options.test.n_repeat
    for i_vp = 1:size(options.test.voice_pairs, 1)

        condition = struct();

        condition.ref_voice = options.test.voice_pairs(i_vp, 1);
        condition.dir_voice = options.test.voice_pairs(i_vp, 2);           

        condition.vocoder = 0;

        condition.visual_feedback = 1;

        % Do not remove these lines
        condition.i_repeat = ir;
        condition.done = 0;
        condition.attempts = 0;

        if ~isfield(test,'conditions')
            test.conditions = orderfields(condition);
        else
            test.conditions(end+1) = orderfields(condition);
        end

    end
end

% Randomization of the order
%options.n_blocks = length(test.conditions)/options.test.block_size;
test.conditions = test.conditions(randperm(length(test.conditions)));

%================================================== Build training block

training = struct();

for ir = 1:options.training.n_repeat
    for i_vp = 1:size(options.training.voice_pairs, 1)

        condition = struct();

        condition.ref_voice = options.training.voice_pairs(i_vp, 1);
        condition.dir_voice = options.training.voice_pairs(i_vp, 2);           

        condition.vocoder = 0;

        condition.visual_feedback = 1;

        % Do not remove these lines
        condition.i_repeat = ir;
        condition.done = 0;
        condition.attempts = 0;

        if ~isfield(training,'conditions')
            training.conditions = orderfields(condition);
        else
            training.conditions(end+1) = orderfields(condition);
        end

    end
end

% for testing purposes limit training set to 1 or 2 trials;
% training.conditions = training.conditions(1);
% this is useless, it won't stop if you make errors... 

% Randomization of the order
%training.conditions = training.conditions(randperm(length(training.conditions)));

%====================================== Create the expe structure and save


expe.test = test;
expe.training = training;
                
if isfield(options, 'res_filename')
    save(options.res_filename, 'options', 'expe');
else
    warning('The test file was not saved: no filename provided.');
end



