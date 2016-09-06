function results2txt
    % cd('/home/paolot/results/Emotion');
    % cd('/home/paolot/Dropbox/Results/Emotion');
    cd('~/Dropbox/data/deb');

    fileID = fopen('allResults.txt', 'wt');
%      fprintf(fileID,'subID\tphase\tvoice\tface\tcongruency\tacc\tRT \n');
    fprintf(fileID,'subID\tphase\tcue\tatt\tvoice\tface\tcongruency\tacc\tRT \n');

    fileAve = fopen('meanResults.txt', 'wt');
    fprintf(fileAve,'subID\tphase\tMeanAcc\tAccCongr\tAccIncon\tAccSAd\tAccJoyful\tAccAngry');
    fprintf(fileAve,'\tMeanRT\tRtCongr\tRtIncon\tRtSAd\tRtJoyful\tRtAngry\n');

    files = dir('*.mat');
    nFiles = length(files);
    for ifiles = 1:nFiles
        load(files(ifiles).name);
        if (~ exist('resp', 'var') && ~ exist('results', 'var'))
            fprintf('%s does not have response values\n', files(ifiles).name);
        else
            [~, startIndex] = regexp(files(ifiles).name,'emo_');
            [endIndex, ~] = regexp(files(ifiles).name,'.mat');
            ppID = files(ifiles).name(startIndex+1 : endIndex-1);
            if exist('resp', 'var')
                exportDataOld(ppID, resp, fileID, fileAve)
            end
            if exist('results', 'var')
                exportDataNew(ppID, results, fileID, fileAve)
            end
        end
    end
    fclose(fileID);
    fclose(fileAve);
end

function exportDataNew(ppID, results, fileID, fileAve)
        
        phases = fieldnames(results);
        nPhases = length(phases);
        for phase = 1 : nPhases
					cues = fieldnames(results.(phases{phase}));
					nCues = length(cues);
					for cue = 1 : nCues
						nAttempts = length(results.(phases{phase}).(cues{cue}).att); 
						for attempt = 1 : nAttempts
							resp = results.(phases{phase}).(cues{cue}).att(attempt).responses;
							exportDataOldExtended(ppID, resp, fileID, fileAve, phases{phase}, cues{cue}, attempt);
						end
					end
				end

end

function exportDataOldExtended(ppID, resp, fileID, fileAve, phase, cue, attempt)
        nResponses = length(resp);
        
        for iresp = 1 : nResponses
            % ntrials = length(results.(phases{iphase}).conditions(iCond).att(iAttempt).differences);
            fprintf(fileID,'%s\t', ppID);
						fprintf(fileID,'%s\t', phase);
            fprintf(fileID,'%s\t', cue);
            fprintf(fileID,'%i\t', attempt);
            fprintf(fileID,'%s\t', resp(iresp).condition.voicelabel);
            fprintf(fileID,'%s\t', resp(iresp).condition.facelabel);
%              fprintf(fileID,'%1.2f\t', resp(iresp).condition.congruent);
            fprintf(fileID,'%i\t', resp(iresp).condition.congruent);
            fprintf(fileID,'%i\t', resp(iresp).correct);
            fprintf(fileID,'%02.3f\t', resp(iresp).response_time);
            fprintf(fileID,'\n');
        end
        % file with averages
        fprintf(fileAve,'%s\t', ppID);
        fprintf(fileAve,'%s\t', phase);
        
        cond = [resp.condition];
        % accuracies
        fprintf(fileAve,'%1.2f\t', mean([resp.correct]) );
        fprintf(fileAve,'%1.2f\t', mean([resp([cond.congruent] == 1).correct]) );
        fprintf(fileAve,'%1.2f\t', mean([resp([cond.congruent] == 0).correct]) );
        fprintf(fileAve,'%1.2f\t', mean([resp(strcmp({cond.voicelabel}, 'sad')).correct]) );
        fprintf(fileAve,'%1.2f\t', mean([resp(strcmp({cond.voicelabel}, 'joyful')).correct]) );
        fprintf(fileAve,'%1.2f\t', mean([resp(strcmp({cond.voicelabel}, 'angry')).correct]) );
        
        % RT
        fprintf(fileAve,'%02.3f\t', mean([resp.response_time]) );
        fprintf(fileAve,'%02.3f\t', mean([resp([cond.congruent] == 1).response_time]) );
        fprintf(fileAve,'%02.3f\t', mean([resp([cond.congruent] == 0).response_time]) );
        fprintf(fileAve,'%1.2f\t', mean([resp(strcmp({cond.voicelabel}, 'sad')).response_time]) );
        fprintf(fileAve,'%1.2f\t', mean([resp(strcmp({cond.voicelabel}, 'joyful')).response_time]) );
        fprintf(fileAve,'%1.2f\t', mean([resp(strcmp({cond.voicelabel}, 'angry')).response_time]) );
        
        fprintf(fileAve,'\n');
        clear expe options resp
end

function exportDataOld(ppID, resp, fileID, fileAve)
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