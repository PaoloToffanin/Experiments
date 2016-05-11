function options = sos_stimuliOptions(options)
% EXPE_OPTIONS([OPTIONS])
%   Defines general options for the experiment, for instance:
%   - where the results are saved
%   - where the stimuli can be found
%
%   If called with an argument, the OPTIONS structure is updated. Otherwise
%   it is created.

%% ----------------- Signal
options.fs = 44100;
options.attenuation_dB = 3; % General attenuation
options.ear = 'both'; % right, left or both

options.test.n_sentences = 13; % Number of test sentences per condition
options.training.n_sentences = 6;
%------- Generate voice conditions from F0 and VTL values
options.test.f0s  = [4, 9, 12]; % Semitones re. original
options.test.vtls = [4, 9, 12]; % Semitones re. original

options.targetSex = 'Man'; % voice to test, otherwise Man
options.maskerSex = 'Vrouw'; 