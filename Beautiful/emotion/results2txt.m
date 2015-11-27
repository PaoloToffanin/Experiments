
% cd('/home/paolot/results/Emotion');
cd('/home/paolot/Dropbox/Results/Emotion');

fileID = fopen('allResults.txt', 'wt');
fprintf(fileID,'subID\tphase\tvoice\tface\tcongruency\tacc\tRT \n');

fileAve = fopen('meanResults.txt', 'wt');
fprintf(fileAve,'subID\tphase\tMeanAcc\tAccCongr\tAccIncon\tAccSAd\tAccJoyful\tAccAngry');
fprintf(fileAve,'\tMeanRT\tRtCongr\tRtIncon\tRtSAd\tRtJoyful\tRtAngry\n');

files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    if ~ exist('resp', 'var')
        fprintf('%s does not have response values\n', files(ifiles).name);
    else
        [~, startIndex] = regexp(files(ifiles).name,'emo_');
        [endIndex, ~] = regexp(files(ifiles).name,'.mat');
        ppID = files(ifiles).name(startIndex+1 : endIndex-1);
        nResponses = length([resp.response]);
        
        for iresp = 1 : nResponses
            % ntrials = length(results.(phases{iphase}).conditions(iCond).att(iAttempt).differences);
            fprintf(fileID,'%s\t', ppID);
            if isfield(resp, 'phase')
                fprintf(fileID,'%s\t', resp(iresp).phase);
            else 
                fprintf(fileID,'xxx\t');
            end
            fprintf(fileID,'%s\t', resp(iresp).condition.voicelabel);
            fprintf(fileID,'%s\t', resp(iresp).condition.facelabel);
            fprintf(fileID,'%1.2f\t', resp(iresp).condition.congruent);
            fprintf(fileID,'%i\t', resp(iresp).response.correct);
            fprintf(fileID,'%02.3f\t', resp(iresp).response.response_time);
            fprintf(fileID,'\n');
        end
        % file with averages
        fprintf(fileAve,'%s\t', ppID);
        if isfield(resp, 'phase')
            fprintf(fileAve,'%s\t', resp(iresp).phase);
        else
            fprintf(fileAve,'xxx\t');
        end
        cond = [resp.condition];
        results = [resp.response];
        % accuracies
        fprintf(fileAve,'%1.2f\t', mean([results.correct]));
        fprintf(fileAve,'%1.2f\t', mean([results([cond.congruent] == 1).correct]));
        fprintf(fileAve,'%1.2f\t', mean([results([cond.congruent] == 0).correct]));
        fprintf(fileAve,'%1.2f\t', mean([results(strcmp({cond.voicelabel}, 'sad')).correct]));
        fprintf(fileAve,'%1.2f\t', mean([results(strcmp({cond.voicelabel}, 'joyful')).correct]));
        fprintf(fileAve,'%1.2f\t', mean([results(strcmp({cond.voicelabel}, 'angry')).correct]));
        
        % RT
        fprintf(fileAve,'%02.3f\t', mean([results.response_time]));
        fprintf(fileAve,'%02.3f\t', mean([results([cond.congruent] == 1).response_time]));
        fprintf(fileAve,'%02.3f\t', mean([results([cond.congruent] == 0).response_time]));
        fprintf(fileAve,'%1.2f\t', mean([results(strcmp({cond.voicelabel}, 'sad')).response_time]));
        fprintf(fileAve,'%1.2f\t', mean([results(strcmp({cond.voicelabel}, 'joyful')).response_time]));
        fprintf(fileAve,'%1.2f\t', mean([results(strcmp({cond.voicelabel}, 'angry')).response_time]));
        
        fprintf(fileAve,'\n');
        clear expe options resp
    end
end

fclose(fileID);
fclose(fileAve);