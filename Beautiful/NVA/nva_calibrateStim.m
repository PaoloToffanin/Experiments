function nva_calibrateStim

    pathsToAdd = {'../lib/MatlabCommonTools/'};
    for iPath = 1 : length(pathsToAdd)
        addpath(pathsToAdd{iPath})
    end
    
    options = nva_options;
    options.home = getHome;
    participant.name = 'test';
    options = nva_defineDirectories(options, participant);
    
    [noise, fs] = audioread([options.wordsFolder '00Spraakruis.wav']);
    rmsM = rms(noise);

    sndFiles = dir([options.wordsFolder  '*.wav']); 
    sndFiles = sndFiles(cellfun('isempty', strfind({sndFiles.name}, '00Spraakruis.wav')));
    nfiles = length(sndFiles);
    tmrVect = sort(mod(1 : nfiles, 3) + 1);
    for ifile = 1 : nfiles
        fprintf('tmr %i\n', options.TMR(tmrVect(ifile)));
        [y, fs] = audioread([options.wordsFolder sndFiles(ifile).name]);
        % christina plays stimuli with noise at different levels
        target = remove_silence(y(:, 1), fs);
        rmsT = rms(target);
        silenceInFs = floor(0.25*fs);
        target = [zeros(silenceInFs, 1); target; zeros(silenceInFs, 1)];
%         masker = noise(1 : length(target))./rmsM.*(rmsT/10^(stimulus.(list{iList}).TMR/20));
        masker = noise(1 : length(target)) ./ rmsM .* (rmsT/10^(options.TMR(tmrVect(ifile))/20));
        addpath('../lib/MatlabCommonTools/');
        masker = cosgate(masker, fs, 50e-3); %50ms cosine ramp to both beginning and end of masker signal.
        masker = zeros(size(target)); % this is for calibration, to make sure we measure the right 
        % sound intensity
        xOut = (target+masker)*10^(-options.attenuation_dB/20);
        what2play = audioplayer([xOut], fs);
        playblocking(what2play); % otherwise we cannot record
    end
%     let's tailore the noise:

    masker = noise(1 : floor(4*fs))./rmsM.*(rmsT/10^(options.TMR(1).TMR/20));
    masker = cosgate(masker, fs, 50e-3);
    target = zeros(size(masker)); % this is also only for calibration
    xOut = (target+masker)*10^(-options.attenuation_dB/20);
    what2play = audioplayer([xOut], fs);
    
    for ifile = 1 : 10
        playblocking(what2play); 
    end
    
    
    
end