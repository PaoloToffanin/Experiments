function Out = RMS_safe(In,fs,Band,target_fs)
%RMS_safe - Root Mean Square with arguments for safe measure
%   OUT = RMS_SAFE(IN, FS, BAND, TARGET_FS) 
%       Computes RMS of IN assuming sample rate is FS. IN is resampled at
%       TARGET_FS and filtered in BAND (a two elements vector to define
%       cutoff freqencies of a bandpass filter) before computation. The
%       signal is filtered with two Buttherworth filters of order-4 with
%       phase compensation.
%
%       If IN is a filename, the file is opened using WAVREAD. FS is
%       overriden by the result of WAVREAD.
%
%   AUTHOR
%       Et. Gaudrain (egaudrain@olfac.univ-lyon1.fr),
%       Laboratoire Neurosciences Sensorielles, Comportement, Cognition
%       CNRS UMR 5020, 50 av. Tony Garnier, 69366 LYON Cedex 07, France

% First released on 2007-04-16.

if isstr(In)
    [In fs] = wavread(In);
end

if fs~=target_fs
    In = resample(In, target_fs, fs);
end

[b a] = butter(4, Band/target_fs * 2);
In = filter(b, a, In);
In = filter(b, a, In(end:-1:1));
In = In(end:-1:1);

Out = sqrt(mean(In.^2));

