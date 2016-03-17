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

rng('shuffle')
run('../defineParticipantDetails.m')

options = sos_options(participant);

%-------------------------------------------------

if ~exist(res_foldername, 'dir')
    mkdir(res_foldername);
    expe_build_conditions(options);
    
else
    opt = char(questdlg(sprintf('Found "%s". Use this data?', res_foldername),'SOS','OK','Cancel','OK'));
    if strcmpi(opt, 'Cancel')
        return
    end
end

expe_main(options, session);

%------------------------------------------
%% Clean up the path

for i=1:length(paths2Add)
    rmpath(paths2Add);
end