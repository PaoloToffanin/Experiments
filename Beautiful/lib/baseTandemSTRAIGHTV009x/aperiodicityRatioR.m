function apStructure = aperiodicityRatioR(x,sourceStruture,sideMargin)
%   apStructure = aperiodicityRatio(x,sourceStruture)
%   Aperiodicity extraction using dual clue

%   Designed and coded by Hideki Kawahara
%   17/Oct./2008
%   06/Jan./2008 reduced computation (approximation)

%---- initialize parameters -------
tic;
fs = sourceStruture.samplingFrequency;
f0 = sourceStruture.f0;
locations = sourceStruture.temporalPositions;
targetF0 = min(200,max(32,min(f0(f0>0)))); % 32 and 200 Hz are safe guards
%----

aperiodicityWithOriginalTime = ...
    bandwiseAperiodicity(x,sourceStruture,fs,sideMargin,30);
[stretchedSignal,stretchedLocations] = normalizeSignal(x,fs,f0,locations,targetF0);
fixedSource = sourceStruture;
fixedSource.f0 = fixedSource.f0*0+targetF0;
fixedSource.temporalPositions = stretchedLocations;
aperiodicityWithNormalizedTime = ...
    bandwiseAperiodicity(stretchedSignal(:),fixedSource,fs,sideMargin,round(2000/targetF0));

apStructure.dateOfExtraction = datestr(now);
apStructure.stretchedSignal = stretchedSignal;
apStructure.residualMatrixOriginal = aperiodicityWithOriginalTime.residualMatrix;
apStructure.cutOffListOriginal = aperiodicityWithOriginalTime.cutOffList;
apStructure.residualMatrixFix = aperiodicityWithNormalizedTime.residualMatrix;
apStructure.cutOffListFix = aperiodicityWithNormalizedTime.cutOffList;
apStructure.temporalPositions = locations;
apStructure.targetF0 = targetF0;
apStructure.f0 = f0;
apStructure.periodicityLevel = sourceStruture.periodicityLevel;
apStructure.solutionConditionsOriginal = aperiodicityWithOriginalTime.solutionConditions;
apStructure.solutionConditionsFix = aperiodicityWithNormalizedTime.solutionConditions;
apStructure.samplingFrequency = fs;
apStructure.elapsedTimeForAperiodicity = toc;
apStructure.procedure = 'aperiodicityRatio';

%---- internal functions ----
function [stretchedSignal,stretchedLocations] = ...
    normalizeSignal(x,fs,f0,locations,targetF0)
%targetF0 = max(32,min(f0(f0>0)));
f0(f0<targetF0) = f0(f0<targetF0)*0+targetF0;
extendedX = reshape([x,zeros(length(x),3)]',length(x)*4,1);
interpolatedX = conv(hanning(7),extendedX);
originalSignalTime = (0:length(interpolatedX)-1)/(fs*4);
interpolatedF0 = interp1(locations,f0, ...
    originalSignalTime,'linear','extrap');
stretchedTime = cumsum(interpolatedF0/targetF0/(fs*4));
stretchedSignal4 = interp1(stretchedTime,interpolatedX,...
    0:1/(fs*4):stretchedTime(end),'linear','extrap');
stretchedLocations = ...
    interp1(originalSignalTime,stretchedTime,locations,'linear','extrap');
stretchedSignal = decimate(stretchedSignal4,4);

function [hHP,hLP] = designQMFpairOfFilters(fs)
%   This routine is not optimized. But, it is practically functional.
%   Power sum of each frequency response is within 3% deviation around
%   crossover frequency. This part can be replaced by discrete wavelet
%   transform.

%fs = 22050; % This is only an example.
boundaryFq = fs/4;
transitionWidth = 1/4;
levelTolerancePassBand = 0.1; % 4% fluctuation
levelToleranceStopBand = 0.002; % -60 dB
mags = [0 1];
fcuts = boundaryFq*2.0.^(transitionWidth*[-1 1]);
devs = [levelToleranceStopBand levelTolerancePassBand];
cutOffShift = 1/17.3; % numerically adjusted

[nTapsHP,WnHP,betaHP,ftypeHP] = ...
    kaiserord(fcuts*2.0.^(-cutOffShift),mags,devs,fs);

[nTapsLP,WnLP,betaLP,ftypeLP] = ...
    kaiserord(fcuts*2.0.^(cutOffShift),mags(end:-1:1),devs(end:-1:1),fs);

hLP = fir1(nTapsLP,WnLP,ftypeLP,kaiser(nTapsLP+1,betaLP),'noscale');
hHP = fir1(nTapsHP,WnHP,ftypeHP,kaiser(nTapsHP+1,betaHP),'noscale');

function aperiodicityStr = ...
    bandwiseAperiodicity(wholeSignal,sourceStr,samplingFrequency,nOrder,windowLengthMs)
PermissibleLimit = 0.2;
TBLimProduct = [3.5794 5.1728 6.4941];
OrderList = [2 3 4];

%nominalCutOff = 1000;
nominalCutOff = interp1(OrderList,...
    TBLimProduct/PermissibleLimit/(windowLengthMs/1000),nOrder,'linear','extrap');
nFrames = size(sourceStr.f0,1);
[hHP,hLP] = designQMFpairOfFilters(samplingFrequency);

cutOffList = (samplingFrequency/4);
while cutOffList(end) > nominalCutOff
    cutOffList = [cutOffList; cutOffList(end)/2];
end;
cutOffList = cutOffList(1:end-1);

nMarginBias = nOrder; % 2 may be reasonable
residualMatrix = zeros(length(cutOffList)+1,nFrames);
wholeSignal = [wholeSignal;0.0001*randn(length(hHP)*2,1)];

for ii = 1:length(cutOffList)
    fsTmp = cutOffList(ii)*2;
    highSignal = fftfilt(hHP,wholeSignal);
    lowSignal = fftfilt(hLP,wholeSignal);
    downSampledHighSignal = highSignal(1:2:end);
    residualObj = f0PredictionResidualFixSegmentWR(downSampledHighSignal,...
        fsTmp,sourceStr,nMarginBias,-length(hHP)/2/fsTmp,windowLengthMs);
    wholeSignal = [lowSignal(1:2:end);0.0001*randn(length(hHP)*2,1)];
    residualMatrix(length(cutOffList)+1-ii+1,:) = residualObj.rmsResidual';
    solutionConditions(ii).conditionNumberList = residualObj.conditionNumberList;
end;
residualObjW = f0PredictionResidualFixSegmentWR(wholeSignal,...
    fsTmp,sourceStr,nMarginBias,-length(hLP)/2/fsTmp,windowLengthMs);
residualMatrix(1,:) = residualObjW.rmsResidual';
aperiodicityStr.residualMatrix = residualMatrix;
aperiodicityStr.solutionConditions = solutionConditions;
aperiodicityStr.cutOffList = cutOffList(end:-1:1);


