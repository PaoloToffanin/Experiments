function y = remove_silence(y, fs)

    addpath('../lib/MatlabCommonTools/');

    [b, a] = butter(3, 50*2/fs, 'low');
    e = max(filtfilt(b, a, max(y, 0)), 0);

    e = cosgate(e, fs, 100e-3);

    c = 2*max([e(1:floor(750e-3*fs)); e(end-floor(750e-3*fs):end)]);

    % Onset
    i1 = find(e(1:end-1)<c & e(2:end)>=c, 1);

    % Offset
    i2 = find(e(1:end-1)>=c & e(2:end)<c, 1, 'last');

    m = floor(20e-3*fs);

    i1 = i1 - m;
    i2 = i2 + m;

    y = cosgate(y(i1:i2), fs, 1e-3);
    rmpath('../lib/MatlabCommonTools/');
    
end