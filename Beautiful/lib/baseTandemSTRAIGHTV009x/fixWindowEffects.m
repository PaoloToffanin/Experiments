function spectrogramStructureOut = ...
    fixWindowEffects(spectrogramStructureIn,sourceStructure, ...
    windowWidthRatio,exponentValue,floorValue)

spectrogramStructureOut = spectrogramStructureIn;
fs = sourceStructure.samplingFrequency;
f0 = sourceStructure.f0;
STRAIGHTspectrum = spectrogramStructureIn.spectrogramSTRAIGHT;
fixedSpectrum = STRAIGHTspectrum;
for ii = 1:length(f0)
    if f0 > 0
        fixedSpectrum(:,ii) = ...
            timeWindowingCompensation(STRAIGHTspectrum(:,ii),fs,f0(ii),...
            windowWidthRatio,exponentValue,floorValue);
    end;
end;
spectrogramStructureOut.spectrogramSTRAIGHT = fixedSpectrum;