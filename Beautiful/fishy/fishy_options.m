function options = fishy_options(options, participant)

options.result_path   = [options.home '/Results/Fishy/']; 
if ~exist(options.result_path, 'dir')
    mkdir(options.result_path);
end
options.result_prefix = 'jvo_';
options.locationImages =  [options.home '/imagesBeautiful/fishy/Images/'];

options.extendStructures = false; % fishy_build_conditions, if the expe 
% structures or the results structures need to be extended with an 
% additional attempt

% The current status of the experiment, number of trial and phase, is
% written in the log file. Ideally this file should be on the network so
% that it can be checked remotely. If the file cannot be reached, the
% program will just continue silently.
options.log_file = fullfile('results', 'status.txt');
options.subject_name = participant.name;
options.language = participant.language;
options.kidsOrAdults = participant.kidsOrAdults;
options.res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
