
% cd('/home/paolot/results/gender/');
cd('/home/paolot/Dropbox/Results/Gender/');

fileID = fopen('allResults.txt', 'wt');
fprintf(fileID,'subID\tphase\tf0\tvtl\tface\tword\thands\tbutton\tRT\tIsWoman \n');
% fileAve = fopen('meanResults.txt', 'wt');
% fprintf(fileAve,'subID\tphase\tf0\tvtl\tface\tword\thands\tbutton\tRT \n');


files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    [~, startIndex] = regexp(files(ifiles).name,'gen_');
    [endIndex, ~] = regexp(files(ifiles).name,'.mat');
    ppID = files(ifiles).name(startIndex+1 : endIndex-1);
    phases = fieldnames(results);
    nPhases = length(phases);
    for iphase = 1 : nPhases
        nResponses = length(results.(phases{iphase}).responses);
        for iresp = 1 : nResponses
            % ntrials = length(results.(phases{iphase}).conditions(iCond).att(iAttempt).differences);
            fprintf(fileID,'%s\t', ppID);
            fprintf(fileID,'%s\t', phases{iphase});
            fprintf(fileID,'%i\t', results.(phases{iphase}).responses(iresp).trial.f0);
            fprintf(fileID,'%1.1f\t', results.(phases{iphase}).responses(iresp).trial.vtl);
            fprintf(fileID,'%s\t', results.(phases{iphase}).responses(iresp).trial.face);
            fprintf(fileID,'%s\t', results.(phases{iphase}).responses(iresp).trial.word);
            fprintf(fileID,'%s\t', results.(phases{iphase}).responses(iresp).trial.hands);
            fprintf(fileID,'%i\t', results.(phases{iphase}).responses(iresp).button_clicked);
            fprintf(fileID,'%02.3f\t', results.(phases{iphase}).responses(iresp).response_time);
            % button_clicked = 1 -> yes; button_clicked = 2 -> no; 
            % female = 1;
            % isWoman = 1; % face = man, resp 'no' + face = woman resp = 'yes'
            % isWoman = 1; % face = man, resp 2 + face = woman resp = 1
            fprintf(fileID,'%i\t', (results.(phases{iphase}).responses(iresp).trial.face(1) == 'm' && ...
                results.(phases{iphase}).responses(iresp).button_clicked == 2) || ...
                (results.(phases{iphase}).responses(iresp).trial.face(1) == 'w' && ...
                results.(phases{iphase}).responses(iresp).button_clicked == 1));
            
            
            fprintf(fileID,'\n');
        end
    end
    
%     fprintf(fileID,'%s\t', ppID);
%     fprintf(fileID,'%s\t', phases{iphase});

    
    
%     fprintf(fileID,'%02.3f\t', results.(phases{iphase}).responses(iresp).response_time);

    
end

fclose(fileID);
% fclose(fileAve);