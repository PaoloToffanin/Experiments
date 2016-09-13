function expe_run(subject, session)
%% expe_run(subject,phase)
%
% Entry point to the SOS experiment
% Input Args: 
%           subject => subject number 
%           session => 1 or 2

%% Specify results path

options.result_path   = './results';
options.result_prefix = 'SOS_';

%-------------------------------------------------
%% Set appropriate path

current_dir = fileparts(mfilename('fullpath'));
added_path  = {};

added_path{end+1} = '~/Experiments/Beautiful/lib/vocoder_2015';
addpath(added_path{end});

added_path{end+1} = '~/Experiments/Beautiful/lib/STRAIGHTV40_006b';
addpath(added_path{end});

added_path{end+1} = '~/Experiments/Beautiful/lib/MatlabCommonTools';
addpath(added_path{end});

%-------------------------------------------------

%% Create result dir if necessary
if ~exist(options.result_path, 'dir')
    mkdir(options.result_path);
end

res_foldername = fullfile(options.result_path, sprintf('%s%s', options.result_prefix, subject));
options.res_foldername = res_foldername;

res_filename = fullfile(options.res_foldername, sprintf('%s%s.mat', options.result_prefix, subject));
options.res_filename = res_filename;

if ~exist(res_foldername, 'dir')
    opt = char(questdlg(sprintf('The subject "%s" doesn''t exist. Create it?', subject),'SOS','OK','Cancel','OK'));
    switch lower(opt)
        case 'ok',
            mkdir(res_foldername);
            expe_build_conditions(options); 
        case 'cancel'
            return
        otherwise
            error('Unknown option: %s',opt)
    end
else
    opt = char(questdlg(sprintf('Found "%s". Use this data?', res_foldername),'SOS','OK','Cancel','OK'));
    if strcmpi(opt, 'Cancel')
        return
    end
end

expe_main(options, session);

%------------------------------------------
%% Clean up the path

for i=1:length(added_path)
    rmpath(added_path{i});
end