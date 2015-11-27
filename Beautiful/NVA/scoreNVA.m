function phonemescore = scoreNVA(varargin)
% The list are designed to score based on the number of correctly 
% identified phonemes (phonemescore). The first word of each list is 
% excluded. Because each list contains 33 phonemes, every phoneme counts 
% for ~3%. The correct score in % is obtained by multiplying the nr of 
% correctly identified phonemes with 3, and increase this number with 1% 
% when it is higher than 50%. In formula: 

% Score = 3 * Ncorrect            for  0 <= Ncorrect <= 16 (11 * 3 / 2)
% Score = 3 * Ncorrect + 1      for 17 <= Ncorrect <=33 (11 * 3)
   
    pathsToAdd = {'../lib/MatlabCommonTools/'};
    for iPath = 1 : length(pathsToAdd)
        addpath(pathsToAdd{iPath})
    end
    
    options.home = getHome;
    options.responsesFolder = [options.home '/results/NVA/'];
    files = dir([options.responsesFolder '*.mat']);
    if nargin ~= 0
        files = dir([options.responsesFolder '*' varargin{1} '*.mat']);
        
    end
    
%     nLists = 2;
%     phonemescore = zeros(1, nLists, length(files)); %
    for ifile = 1 : length(files)
        load([options.responsesFolder files(ifile).name]) % put . between responsesFolder files
        lists = fieldnames(responses);
        phonemescore = zeros(1, length(lists)); %
        for iList = 1 : length(lists)
            % exclude first word
            responses.(lists{iList}).scores(1) = [];
            responses.(lists{iList}).word{1} = [];
            % 
            scores = [responses.(lists{iList}).scores(:)];
            words  = [responses.(lists{iList}).word{:}]; 
            
            phonemescore(iList) = getScore(scores);
            
        end
        % phonemescore = mean(phonemescore);
        disp(mean(phonemescore));
    end
%     phonemescore = mean(phonemescore);
    
end


function phonemescore = getScore(scores)
    phonemescore = 0;
    %% this is for the clinic set up
%     for iscore = 1 : length(scores)
%         switch scores{iscore}
%             % case 'zero' % add nothing
%             case 'one'
%                 phonemescore = phonemescore + 1 * 3;
%             case 'two'
%                 phonemescore = phonemescore + 2 * 3;
%             case 'ALL'
%                 phonemescore = phonemescore + 3 * 3;
%         end
%     end
    %% this is for the clinic set up
    phonemescore = cellfun('length', scores(1:11));
    if ~ isempty(phonemescore)
        allOnes = find(phonemescore == 1);
        % check which of the scores with one is either 'ALL' or 'zero' since
        % those need to be updated to 0 or 3 whereas the other can stay 1
        phonemescore(allOnes(~cellfun('isempty', strfind([scores{phonemescore == 1}], 'ALL')))) = 3;
        if ~ isempty(find(phonemescore == 1))
            phonemescore(allOnes(~cellfun('isempty', strfind([scores{phonemescore == 1}], 'zero')))) = 0;
        end
        phonemescore = sum(phonemescore * 3);
        
        if phonemescore > 50
            phonemescore = phonemescore + 1;
        end
    else
        disp('It appears one of the subjects had empty responses for one list')
        % deault to zeros then
        phonemescore = 0;
    end
end
