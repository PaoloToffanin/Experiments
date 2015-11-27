%%  Test event locator
%   24/Oct./2008
%   Designed and coded by Hideki Kawahara

tic;
xxq = abs(xx).^2;
avf0 = mean(rc.f0(rc.f0>0));
%nWlength = round(fs/avf0/2)*2+1; % this number must be odd
windowLengthInMS = 10; % baseline length in ms
nWlength = round(5/1000/2*fs)*2+1; % this number must be odd
%localTime = (-round(fs/avf0/2):round(fs/avf0/2))'/fs;
localTime = (-round(5/1000/2*fs):round(5/1000/2*fs))'/fs;
w = hanning(nWlength);
localEnergy = fftfilt(w,xxq);
windowEnergy = sum(w);
meanTimeRaw = fftfilt(-w.*localTime,xxq);
meanTimeNormalize = fftfilt(w,xxq);
meanTimeTime = meanTimeRaw./meanTimeNormalize;
meanDurationRaw = fftfilt(w.*(localTime.^2),xxq);
durationEstimate = sqrt(meanDurationRaw./meanTimeNormalize);
windowDuretion = sqrt(sum(w.*(localTime.^2))/sum(w));
toc
figure;
subplot(411);plot((1:length(x))/fs*1000,x);grid on;
subplot(412);plot((1:length(xx))/fs*1000,10*log10(localEnergy./windowEnergy));grid on;
subplot(413);plot((1:length(meanTimeTime))/fs*1000,meanTimeTime*1000);grid on;
subplot(414);plot((1:length(meanTimeTime))/fs*1000,max(1,windowDuretion./durationEstimate));grid on
