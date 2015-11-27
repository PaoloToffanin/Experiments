%%  Test aperiodicity extraction
%   Designed and coded by Hideki Kawahara
%   19/Oct./2008

fs = 48000;
%fs = 44100;
%fs = 22050;
%fs = 16000;
%fs = 11025;
%fs = 8000;
fsTable = [48000,44100,32000,22050,16000,11025,8000];
targetF0List = 50*2.0.^[0:1/3:2];
sideMargin = 2;
numberOfFs = length(fsTable);
tbproductSD = 0;
tbproductMedian = 0;
itemCount = 0;
for kk = 1:numberOfFs
    fs = fsTable(kk);
    tt = 0:1/fs:2;
    xn = randn(length(tt),1);
    x = zeros(length(tt),1);
    x(1:round(fs/100):end) = 1;

    %%

    rc = exF0candidatesTSTRAIGHTGB(x,fs);

    targetF0 = 1/0.015/2;
    rc.f0 = rc.f0*0+targetF0;
    apStructureNRef = aperiodicityRatio(xn,rc,sideMargin);

    %%
    %targetF0 = 1/0.015;
    medianTableFix = zeros(length(targetF0List),10);
    medianTableOriginal = zeros(length(targetF0List),10);
    sdTableFix = zeros(length(targetF0List),10);
    sdTableOriginal = zeros(length(targetF0List),10);
    cutOffTable = zeros(length(targetF0List),10);

    for jj = 1:length(targetF0List)
        targetF0 = targetF0List(jj);
        rc.f0 = rc.f0*0+targetF0;

        apStructureN = aperiodicityRatio(xn,rc,sideMargin);
        equivalentWindowLength = 2/targetF0;

        %  show results
        if 1 == 2
            figure;
            for ii = 1:size(apStructureN.residualMatrixOriginal,1)
                plot(apStructureNRef.residualMatrixOriginal(ii,:), ...
                    apStructureN.residualMatrixFix(ii,:),'.');
                hold all
            end;
            hold off
            drawnow
        end;

        %
        tbProductFix = diff(-[apStructureN.cutOffListFix;0]*2/apStructureN.targetF0);
        tbProductOriginal = diff(-[apStructureN.cutOffListOriginal;0]*2/apStructureN.targetF0);

        windowSizeOriginal = 0.03;
        windowSizeFix = 2/apStructureN.targetF0;

        originalTime = apStructureN.temporalPositions;
        reliableOriginalIndex = (originalTime>windowSizeOriginal) & ...
            (originalTime<originalTime(end)-windowSizeOriginal);
        fixedTime = originalTime(:).*rc.f0/targetF0;
        reliableFixedIndex = (fixedTime>windowSizeFix) & ...
            (fixedTime<fixedTime(end)-windowSizeFix);

        sortedOriginalResidual = sort(apStructureN.residualMatrixOriginal(:,reliableOriginalIndex)')';
        sortedFixedResidual = sort(apStructureN.residualMatrixFix(:,reliableFixedIndex)')';

        if 1 == 2
            figure;
            plot(sortedOriginalResidual',(1:size(sortedOriginalResidual,2))/size(sortedOriginalResidual,2))
            figure;
            plot(sortedFixedResidual',(1:size(sortedFixedResidual,2))/size(sortedFixedResidual,2))
            drawnow
        end;

        dofOriginal = diff(-[fs/2;apStructureN.cutOffListOriginal;0]*windowSizeOriginal);
        dofFix = diff(-[fs/2;apStructureN.cutOffListFix;0]*2/apStructureN.targetF0);
        fixedChannels = size(sortedFixedResidual,1);
        originalChannels = size(sortedOriginalResidual,1);
        medianTableOriginal(jj,1:originalChannels) = median(sortedOriginalResidual');
        medianTableFix(jj,1:fixedChannels) = median(sortedFixedResidual');
        sdTableOriginal(jj,1:originalChannels) = std(sortedOriginalResidual');
        sdTableFix(jj,1:fixedChannels) = std(sortedFixedResidual');
        cutOffTable(jj,1:fixedChannels) = [apStructureN.cutOffListFix;fs/2]';
    end;

    %%  Show results

    correctionFactor = 0.8;
    figure;

    for ii = 1:length(targetF0List)
        numberOfBands = sum(cutOffTable(ii,:)>0);
        currentWindowLength = 2/targetF0List(ii);
        bwTable = diff([0 cutOffTable(ii,1:numberOfBands)]);
        bwTable(end) = bwTable(end)*correctionFactor;
        tbVector = currentWindowLength*bwTable;
        loglog(tbVector,sdTableFix(ii,1:numberOfBands),'-o');grid on
        hold all
    end;
    hold off
    set(gca,'fontsize',14);
    title(['standard deviations for ' num2str(fs,8) ' (Hz)']);
    xlabel('windowLength*bandWidth')
    ylabel('standard deviation of random level');
    axis([1 1000 0.001 1]);
    fnameOut1 = ['sd' datestr(now,30) 'fs' num2str(fs,8) 'Hz.eps'];
    eval(['print -depsc ' fnameOut1]);

    figure;
    for ii = 1:length(targetF0List)
        numberOfBands = sum(cutOffTable(ii,:)>0);
        currentWindowLength = 2/targetF0List(ii);
        bwTable = diff([0 cutOffTable(ii,1:numberOfBands)]);
        bwTable(end) = bwTable(end)*correctionFactor;
        tbVector = currentWindowLength*bwTable;
        loglog(tbVector,1-medianTableFix(ii,1:numberOfBands),'-o');grid on
        hold all
    end;
    hold off
    set(gca,'fontsize',14);
    title(['1-median for ' num2str(fs,8) ' (Hz)']);
    xlabel('windowLength*bandWidth')
    ylabel('1-median of random level');
    axis([1 1000 0.001 1]);
    fnameOut2 = ['md' datestr(now,30) 'fs' num2str(fs,8) 'Hz.eps'];
    eval(['print -depsc ' fnameOut2]);
    for ii = 1:length(targetF0List)
        numberOfBands = sum(cutOffTable(ii,:)>0);
        currentWindowLength = 2/targetF0List(ii);
        bwTable = diff([0 cutOffTable(ii,1:numberOfBands)]);
        bwTable(end) = bwTable(end)*correctionFactor;
        tbVector = currentWindowLength*bwTable;
        for jj = 1:numberOfBands
            if ~isnan(sdTableFix(ii,jj)*medianTableFix(ii,jj))
                itemCount = itemCount+1;
                tbproductSD = ((itemCount-1)*tbproductSD+tbVector(jj)*sdTableFix(ii,jj))/itemCount;
                tbproductMedian = ((itemCount-1)*tbproductMedian+tbVector(jj)*(1-medianTableFix(ii,jj)))/itemCount;
            end;
        end;
    end;
    tbVector.*(1-medianTableFix(ii,1:numberOfBands))
    tbVector.*(sdTableFix(ii,1:numberOfBands))
    %%
end;
sideMargin
tbproductMedian
tbproductSD
itemCount
