function baselineDurationMap = spectrum2DurationMap(f,r)
%   baselineDurationMap = spectrum2DurationMap(f,r)
%   f   : spectrum structure
%   r   : f0 structure

%   design and coded by Hideki Kawahara
%   24/Oct./2008 
%   28/Oct./2008 numerical differentiations were replaced by FFT based
%   method

lowerLimit = 1500;
fs = r.samplingFrequency;
fftlSynthesis = (size(f.spectrogramSTRAIGHT,1)-1)*2;
bufferIndex = [0:fftlSynthesis/2 -(fftlSynthesis/2-1:-1:1)];
fxForSynthesis = abs(bufferIndex)/fftlSynthesis*fs;
indexForOLA = circshift(bufferIndex',fftlSynthesis/2-1);
latterIndex = fftlSynthesis/2+1:fftlSynthesis;
localTime = ([1:fftlSynthesis]'-1-fftlSynthesis/2)/fs;
FFTbufferTime = [0:fftlSynthesis/2-1 0 -fftlSynthesis/2+1:-1]'/fs;

frequcneyLimitList = fs/4;
while frequcneyLimitList(end) > lowerLimit
    frequcneyLimitList = [frequcneyLimitList;frequcneyLimitList(end)/2];
end;
frequcneyLimitList = sort(frequcneyLimitList);
nBands = size(frequcneyLimitList,1)+1;
frequcneyLimitList = [0;frequcneyLimitList;fs/2];
frequencyLimitIndex = interp1((0:fftlSynthesis-1)/fftlSynthesis*fs, ...
    1:fftlSynthesis,frequcneyLimitList);
frequencyLimitIndex = round(frequencyLimitIndex(:));
bandIndexList = [frequencyLimitIndex(1:end-1) frequencyLimitIndex(2:end)];

nFrames = size(f.temporalPositions,2);
tmpComplexCepstrum = zeros(fftlSynthesis,1);
meanTime = zeros(nFrames,1);
durationList = zeros(nFrames,1);
durationListFdomain = zeros(nFrames,1);
durationMap = zeros(nBands,nFrames);

%indexPosi = [2:fftlSynthesis 1]; % 28/Oct./2008 by H.K.
%indexNega = [fftlSynthesis 1:fftlSynthesis-1]; % 28/Oct./2008 by H.K.
%deltaOmega = 2*pi*fs/fftlSynthesis; % 28/Oct./2008 by H.K.

for ii = 1:nFrames
    doubleSpecSlice = [f.spectrogramSTRAIGHT(:,ii);f.spectrogramSTRAIGHT(end-1:-1:2,ii)];
    tmpCepstrum = fft(log(abs(doubleSpecSlice)')/2);
    tmpComplexCepstrum(latterIndex) = tmpCepstrum(latterIndex')*2;
    tmpComplexCepstrum(1) = tmpCepstrum(1);
    logSpectrum = ifft(tmpComplexCepstrum);
    %groupDelay = ...
    %    -(imag(logSpectrum(indexPosi))-imag(logSpectrum(indexNega)))/2/deltaOmega; 
    % 28/Oct./2008 by H.K.
    amplitude = exp(real(logSpectrum));
    %amplitudeDerivative = (amplitude(indexPosi)-amplitude(indexNega))/2/deltaOmega;
    % 28/Oct./2008 by H.K.
    compositeSpectrum = amplitude+i*imag(logSpectrum);
    diffedCompositeSpectrum = fft(ifft(compositeSpectrum).*FFTbufferTime);
    groupDelay = real(diffedCompositeSpectrum);
    amplitudeDerivative = imag(diffedCompositeSpectrum);
    powerSpectrum = amplitude.^2;
    response = fftshift(real(ifft(exp(ifft(tmpComplexCepstrum)))));
    meanTime(ii) = sum(localTime.*response.^2)/sum(response.^2);
    durationList(ii) = sqrt(sum(((localTime-meanTime(ii)).^2).*response.^2)/sum(response.^2));
    if 1==2 %abs(f.temporalPositions(ii)-0.33) < 0.01
        keyboard
    end;
    for jj = 1:nBands
        bandIndex = bandIndexList(jj,1):bandIndexList(jj,2);
        bandMeanTime = sum(groupDelay(bandIndex).*powerSpectrum(bandIndex)) ...
            /sum(powerSpectrum(bandIndex));
        variance1 = sum(amplitudeDerivative(bandIndex).^2) ...
            /sum(powerSpectrum(bandIndex));
        variance2 = sum(((groupDelay(bandIndex)-bandMeanTime).^2).*powerSpectrum(bandIndex)) ...
            /sum(powerSpectrum(bandIndex));
        durationMap(jj,ii) = sqrt(variance1+variance2);
    end;
end;
baselineDurationMap.meanTime = meanTime;
baselineDurationMap.durationList = durationList;
baselineDurationMap.frequcneyLimitList = frequcneyLimitList;
baselineDurationMap.durationMap = durationMap;