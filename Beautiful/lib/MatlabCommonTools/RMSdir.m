function data = RMSdir(directory)

% RMSDIR - Compute the RMS for all wav files found in DIRECTORY
%   RMSDIR()
%       Compute RMS for wav files found in the current directory. And
%       display result.
%   RMSDIR(DIRECTORY)
%       Compute RMS for wav files found in DIRECTORY. And display result.
%   DATA = RMSDIR() or DATA = RMSDIR(DIRECTORY)
%       Compute RMS for wav files found in current directory or in
%       DIRECTORY and store result in DATA, an struct-array :
%           data(i).filename : Wav file name (without dir)
%           data(i).rms      : RMS of this file
%           data(i).duration : file duration (seconds)
%           

% Copyrights 2005 - Et. Gaudrain, CNRS UMR-5020, Lyon, France.

if nargin<1
    directory = pwd;
else
    if directory(end) == '/'  || directory(end) == '\'
        directory = directory(1:(end-1));
    end
end

disp(['Dir : ' directory '/*.wav']);

filelist = dir([directory '/*.wav']);

for i=1:length(filelist)
    [x, fs] = wavread([directory '/' filelist(i).name]); 
    rms = RMS(x);
    duration = length(x)/fs;  
    if nargout<1
        disp([filelist(i).name ' - RMS : ' num2str(rms) ', duration : ' num2str(duration) ' s'] );
    else
        data(i).filename = filelist(i).name;
        data(i).rms = rms;
        data(i).duration = duration;
    end
end



