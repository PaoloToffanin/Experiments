function options = sos_defineDirectories(options, participant)
% EXPE_OPTIONS([OPTIONS])
%   Defines general options for the experiment, for instance:
%   - where the results are saved
%   - where the stimuli can be found
%
%   If called with an argument, the OPTIONS structure is updated. Otherwise
%   it is created.


%% Set paths

options.paths2Add = {
    '../lib/vocoder_2015', ...
    '../lib/MatlabCommonTools/', ...
    '../lib/STRAIGHTV40_006b', ... 
             }; 
for ipath = 1 : length(options.paths2Add)
    if ~exist(options.paths2Add{ipath}, 'dir')
        error([options.paths2Add{ipath} ' does not exists, check the ../']);
    else
        addpath(options.paths2Add{ipath});
    end
end
    
%----------------- Results
options.home = getHome;
options.result_path   = [getHome '/Results/Sos/'];
if ~exist(options.result_path, 'dir')
    mkdir(options.result_path);
end

% NAWAL has a specific folder for each subject, we want only one structure
% with the results inside of the results folder, 
% NOTE: this is a quick and dirty fix, this has to be removed
% from the script later on
% res_foldername = fullfile(options.result_path, sprintf('%s%s', options.result_prefix, subject));
% options.res_foldername = res_foldername;
options.rec_foldername = [options.result_path 'recordings/' participant.name '/'];
if ~exist(options.rec_foldername, 'dir')
    mkdir(options.rec_foldername);
end
options.result_prefix = 'sos_';
options.res_filename = [options.result_prefix, participant.name, '.mat'];
options.language = participant.language;

%% ----------------- Stimuli path

options.sound_path = [getHome '/sounds/' participant.sentencesCourpus '/sentences/'];
if ~exist(options.sound_path, 'dir')
    error('%s does not exists', options.sound_path);
end
if isempty(dir([options.sound_path '*wav']))
    error('%s does not contain wav files', options.sound_path);
end

options.sentences_file = [getHome '/sounds/' participant.sentencesCourpus '/corpusDefinition.txt'];
if ~exist(options.sentences_file, 'file')
    error('%s file with the sentences does not exist', options.sentences_file);
end

% prevent paolo's computer to get full of rubbish straight processed
% files
options.tmp_path   = [getHome '/sounds/' participant.sentencesCourpus '/cache/'];
if strcmp(java.net.InetAddress.getLocalHost.getHostName, 'debianENT')
    options.tmp_path   = ['/mnt/disk2/processedSounds/' participant.sentencesCourpus '/cache/'];
end 
if ~exist(options.tmp_path, 'dir')
    mkdir(options.tmp_path);
end
% check that there are files inside
sos_doMaskersExist(options);



