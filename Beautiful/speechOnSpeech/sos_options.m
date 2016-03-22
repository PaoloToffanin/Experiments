function options = sos_options(participant)
% EXPE_OPTIONS([OPTIONS])
%   Defines general options for the experiment, for instance:
%   - where the results are saved
%   - where the stimuli can be found
%
%   If called with an argument, the OPTIONS structure is updated. Otherwise
%   it is created.


%% Set paths

paths2Add = {'../lib/vocoder_2015', ...
             '../lib/MatlabCommonTools/', ...
             '../lib/STRAIGHTV40_006b', ... 
             }; 
for ipath = 1 : length(paths2Add)
    if ~exist(paths2Add{ipath}, 'dir')
        error([paths2Add{ipath} ' does not exists, check the ../']);
    else
        addpath(paths2Add{ipath});
    end
end
    
%----------------- Results
options.home = getHome;
options.result_path   = [getHome '/Results/SpeechOnSpeech/'];
if ~exist(options.result_path, 'dir')
    mkdir(options.result_path);
end
    
% NAWAL has a specific folder for each subject, we won't only one structure
% with the results inside of the results folder, 
% NOTE: this is a quick and dirty fix, this has to be removed
% from the script later on
% res_foldername = fullfile(options.result_path, sprintf('%s%s', options.result_prefix, subject));
% options.res_foldername = res_foldername;
options.res_foldername = options.result_path;
options.result_prefix = 'SOS_';
options.res_filename = [options.result_prefix, participant.name, '.mat'];
options.language = participant.language;

%% ----------------- Stimuli path

options.sound_path = '~/sounds/VU_zinnen/sentences/';
if ~exist(options.sound_path, 'dir')
    error('%s does not exists', options.sound_path);
end
if isempty(dir([options.sound_path '*wav']))
    error('%s does not contain wav files', options.sound_path);
end

% prevent paolo's computer to get full of rubbish straight processed
% files
options.tmp_path   = '~/sounds/VU_zinnen/cache/';
if strcmp(java.net.InetAddress.getLocalHost.getHostName, 'debianENT')
    options.tmp_path   = ['/mnt/disk2/processedSounds/VU_zinnen/cache/'];
end 
if ~exist(options.tmp_path, 'dir')
    mkdir(options.tmp_path);
end

options.sentences_file = '~/sounds/VU_zinnen/VU_corpus_definition.txt';
if ~exist(options.sentences_file, 'file')
    error('%s file with the sentences does not exist', options.sentences_file);
end
    
%% ----------------- Signal
options.fs = 44100;
options.attenuation_dB = 3; % General attenuation
options.ear = 'both'; % right, left or both

