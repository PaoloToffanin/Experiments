function fixedSpectrum = ...
    timeWindowingCompensation(STRAIGHTspectrum,fs,f0,windowWidthRatio,exponentValue,floorValue)

alp = exponentValue; 
bet = floorValue; 
fixedSpectrum = STRAIGHTspectrum;
f = [fixedSpectrum;fixedSpectrum(end-1:-1:2)];
fftl = length(f);
halfWindowLength = round(windowWidthRatio*fs/f0/2);
w = blackman(2*halfWindowLength+1);
firResponse = ifft(sqrt(f));
softReciprocalW = (bet^alp+(1-bet^alp).*w.^alp).^(-1/alp);
compensator = ones(fftl,1)*softReciprocalW(1);
compensator(1:halfWindowLength+1) = softReciprocalW(halfWindowLength+1:end);
compensator(end:-1:end-halfWindowLength+1) = ...
    softReciprocalW(halfWindowLength+2:end);
fixedSpectrum = real(fft(compensator.*firResponse)).^2;
fixedSpectrum = fixedSpectrum(1:fftl/2+1);

