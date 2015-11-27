function structureSTRAIGHT = tandem2STRAIGHTe(tSTRAIGHTresults)
%   Convert TANDEM spectrum to STRAIGHT spectrum
%   structureSTRAIGHT = tandem2STRAIGHT(tSTRAIGHTresults)
%   Input
%       tSTRAIGHTresults    : structure variable consists of TANDEM results
%   Output
%       structureSTRAIGHT   : structure variable consists of resulted
%                           : STRAIGHT spectrum
%
%   This function is not designed for general use.
%   This function assumes that the input structure 'tSTRAIGHTresults' is
%   calculated using exTandemSTRAIGHTGeneralBody.
%   Otherwise, please use it with your own risk.

%   Designed and coded by Hideki Kawahara
%   03/Nov./2007
%   09/Dec./2007 home brew interp1H function
%   27/June/2009 extended smoother

%---- copy everything

structureSTRAIGHT = tSTRAIGHTresults;
fftl = tSTRAIGHTresults.analysisConditions.FFTsize;
fs = tSTRAIGHTresults.analysisConditions.samplingFrequency;
tandemSpectrum = tSTRAIGHTresults.originalTANDEMspectrum;
q1 = tSTRAIGHTresults.analysisConditions.compensationCoefficient;
f0 = tSTRAIGHTresults.analysisConditions.assumedF0;
if isfield(tSTRAIGHTresults.analysisConditions,'DCcorrection')
    DCcorrection = tSTRAIGHTresults.analysisConditions.DCcorrection;
else
    DCcorrection = 1;
end;

doubleFrequencyAxis = (0:2*fftl-1)'/fftl*fs-fs;
doubleSpectrum = [tandemSpectrum;tandemSpectrum];

%   Note on DCcorrection
%   F0 adaptive smoothing using rectangular smoother by using a trick
%   and integrated function of DC component substitution with reliable
%   and hypothesized information

if DCcorrection
    %---shaper design------------
    frequencyFragmentIndex = 0:f0/fs*fftl;
    shaperIndex = [-frequencyFragmentIndex(end:-1:2) frequencyFragmentIndex]';
    shaper = 0.5+0.5*cos(pi*shaperIndex/(f0/fs*fftl));
    %---filler calculation and substitution (tricky!!)------------
    filler = ...
        interp1H(doubleFrequencyAxis,doubleSpectrum,...
        f0-abs(shaperIndex)/fftl*fs,'linear','extrap');
    doubleSpectrum(fftl+shaperIndex+1) = ...
        doubleSpectrum(fftl+shaperIndex+1).*(1-shaper) ...
        +filler.*shaper;
end;

%---smoothing using rectangular smoother-----------
if 1 == 2
    doubleSegment = cumsum(doubleSpectrum*(fs/fftl));
    centers = (0:fftl/2)'/fftl*fs;
    lowLevels = ...
        interp1H(doubleFrequencyAxis+fs/fftl/2,doubleSegment, ...
        centers-f0/2,'linear','extrap');
    highLevels = ...
        interp1H(doubleFrequencyAxis+fs/fftl/2,doubleSegment, ...
        centers+f0/2,'linear','extrap');
    smoothPsgram = max(100*eps,(highLevels-lowLevels)/f0);
end;
smoothPsgram = f0AdaptiveRectangularSmoother(doubleSpectrum,fftl,f0,doubleFrequencyAxis)

%  nearly optimal frequency domain inverse filtering using cepstrum lifter
%
if length(q1) > 1
    %   This is for traiangular smoother
    
elseif q1 ~= 0
    quefrencyAxis = [0:fftl/2, -(fftl/2-1:-1:1)]/fs;
    tmpLogSpectrum = log(smoothPsgram(:));
    tmpCepstrum = real(fft([tmpLogSpectrum;tmpLogSpectrum(end-1:-1:2)]));
    normalizedQuefrency = min(2,2*abs(quefrencyAxis*f0));
    lifter = 1.0-q1*(1-cos(pi*normalizedQuefrency))';
    tmpFixedPsgram = exp(real(ifft(tmpCepstrum.*lifter)));
    structureSTRAIGHT.sliceSTRAIGHT = tmpFixedPsgram(1:fftl/2+1);
else
    sliceSTRAIGHT = smoothPsgram(:);
    structureSTRAIGHT.sliceSTRAIGHT = sliceSTRAIGHT(1:fftl/2+1);
end;
structureSTRAIGHT.sliceTANDEM = doubleSpectrum(fftl+(1:fftl/2+1));

function smoothPsgram = f0AdaptiveRectangularSmoother(doubleSpectrum,fftl,f0,doubleFrequencyAxis)
doubleSegment = cumsum(doubleSpectrum*(fs/fftl));
centers = (0:fftl/2)'/fftl*fs;
lowLevels = ...
    interp1H(doubleFrequencyAxis+fs/fftl/2,doubleSegment, ...
    centers-f0/2,'linear','extrap');
highLevels = ...
    interp1H(doubleFrequencyAxis+fs/fftl/2,doubleSegment, ...
    centers+f0/2,'linear','extrap');
smoothPsgram = max(100*eps,(highLevels-lowLevels)/f0);
return;


