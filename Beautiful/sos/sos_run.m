function sos_run
% function sos_run(subject, session)
%% expe_run(subject,phase)
%
% Entry point to the SOS experiment
% Input Args: 
%           subject => subject number 
%           session => 1 or 2
% example: 
% expe_run('1', '1')

close all

rng('shuffle')
run('../defineParticipantDetails.m')


options = sos_stimuliOptions;
options = sos_defineDirectories(options, participant);
options = sos_instructions(options, participant.language);
if ~isfield(options, 'instructions')
    disp('Instructions are not defined')
    return
end

%-------------------------------------------------

% if ~exist([options.res_foldername options.res_filename], 'file')
    sos_build_conditions(options);
%     expe_build_conditions(options);
    % let's get rid of this, it's alwasy inconvenient
% else
%     opt = char(questdlg(sprintf('Found "%s". Use this data?', options.res_foldername),'SOS','OK','Cancel','OK'));
%     if strcmpi(opt, 'Cancel')
%         return
%     end
% end

% N: session = 1; % what do we need the session for?
% N: sos_main(options, session);
% PT: session is a bit criptic, let's replace with the phase name
% expe_main(options, 'test');
% maybe at a later stage, let's stick to Nawal's convention for now and
% modify later
sos_main(options, 'training');

sos_main(options, 'test');
% should we enquire about starting session 2?
% expe_main(options, 2);
% sessions should simply be removed
%------------------------------------------
%% Clean up the path

for iPath = 1 : length(options.paths2Add)
    rmpath(options.paths2Add{iPath});
end