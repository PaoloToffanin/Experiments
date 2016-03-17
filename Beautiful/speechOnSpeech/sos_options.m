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
options.result_path   = [getHome '/Results/SpeechOnSpeech'];
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
res_filename = [options.res_foldername, options.result_prefix, participant.name, '.mat'];
options.res_filename = res_filename;



%----------------- Stimuli path

options.sound_path = '~/Sounds/sentences NL VU/spraak';
% prevent paolo's computer to get full of rubbish straight processed
% files
if strcmp(java.net.InetAddress.getLocalHost.getHostName, 'debianENT')
    options.tmp_path   = ['/mnt/disk2/processedSounds/' options.language '_CV/'];
else
    mkdir(options.tmp_path);
end 


options.tmp_path   = '~/Sounds/sentences NL VU/cache';
options.sentences_file = '~/Sounds/sentences NL VU/00 VU_lijst_woorden.txt';

%----------------- Signal

options.fs = 44100;

if test_machine
    options.attenuation_dB = 3; % General attenuation
else
    options.attenuation_dB = 3; % General attenuation
end
options.ear = 'both'; % right, left or both


