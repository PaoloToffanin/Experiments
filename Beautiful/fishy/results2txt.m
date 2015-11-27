cd([options.home '/results/Fishy/']);
% cd('/home/paolot/resultsBeautiful/Fishy');
fileID = fopen('summaryResults.txt','wt');
fprintf(fileID,'subID\tphase\tlabelV1\tf0V1\tserV1\tlabelV2\tf0V2\tserV2\tatt\tduration\tnTrials\tthrs\tacc\tRT \n');
% cd('/Users/dbaskent/resultsFishy/');
% cd('/home/paolot/resultsFishy/');
files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    [~, startIndex] = regexp(files(ifiles).name,'jvo_');
    [endIndex, ~] = regexp(files(ifiles).name,'.mat');
    ppID = files(ifiles).name(startIndex+1 : endIndex-1);
    phases = fieldnames(results);
    nPhases = length(phases);
    for iphase = 1 : nPhases
        nCond = length(results.(phases{iphase}).conditions);
        for iCond = 1 : nCond
            nAttempts = length(results.(phases{iphase}).conditions(iCond).att);
            for iAttempt = 1 : nAttempts
                % ntrials = length(results.(phases{iphase}).conditions(iCond).att(iAttempt).differences);
                fprintf(fileID,'%s\t', ppID);
                fprintf(fileID,'%s\t', phases{iphase});
                fprintf(fileID,'%s\t', options.(phases{iphase}).voices(options.(phases{iphase}).voice_pairs(iCond,1)).label);
                fprintf(fileID,'%i\t', options.(phases{iphase}).voices(options.(phases{iphase}).voice_pairs(iCond,1)).f0);
                fprintf(fileID,'%1.2f\t', options.(phases{iphase}).voices(options.(phases{iphase}).voice_pairs(iCond,1)).ser);
                fprintf(fileID,'%s\t', options.(phases{iphase}).voices(options.(phases{iphase}).voice_pairs(iCond,2)).label);
                fprintf(fileID,'%i\t', options.(phases{iphase}).voices(options.(phases{iphase}).voice_pairs(iCond,2)).f0);
                fprintf(fileID,'%1.2f\t', options.(phases{iphase}).voices(options.(phases{iphase}).voice_pairs(iCond,2)).ser);
                fprintf(fileID,'%i\t', iAttempt);
                fprintf(fileID,'%f\t', results.(phases{iphase}).conditions(iCond).att(iAttempt).duration);
                fprintf(fileID,'%i\t', length([results.(phases{iphase}).conditions(iCond).att(iAttempt).differences]));
                if isempty(results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold)
                    fprintf(fileID,'NaN\t');
                else
                    fprintf(fileID,'%2.2f\t', ...
                        results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
                end
                fprintf(fileID,'%1.2f\t', ...
                    sum([results.(phases{iphase}).conditions(iCond).att(iAttempt).responses.correct]) / ...
                    length(results.(phases{iphase}).conditions(iCond).att(iAttempt).responses));
                fprintf(fileID,'%2.2f\t', ...
                    mean([results.(phases{iphase}).conditions(iCond).att(iAttempt).responses.response_time]));
%                 fprintf(fileID,'%2.2f ', ...
%                 results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
%                 fprintf(fileID,'%2.2f ', ...
%                 results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
%                 fprintf(fileID,'%2.2f ', ...
%                 results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
                fprintf(fileID,'\n');
            end
        end
    end
%    fprintf(fileID,'%s\n',C{row,:});
end

fclose(fileID);