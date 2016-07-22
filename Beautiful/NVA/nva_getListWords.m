function [nvaLists, stopNow] = nva_getListWords(options, stopNow)
	
    fileID = fopen(options.listsFile, 'rt');
    adultsVersion = false;
    if strfind(options.listsFile, 'Adult')
        adultsVersion = true;
    end
    if adultsVersion
        lists = textscan(fileID,'%s ');
        lists = reshape(lists{:}, 45, 12)';
        lists(:, 16:end) = []; % this is to remove the repetitions
    else
        lists = textscan(fileID,'%s %s %s %s %s');
    end
    fclose(fileID);
    
    choosenLists = randperm(size(lists, 2));
    choosenLists = choosenLists(1 : options.nLists);
    
    % make word letters displayable and consistent with sound file names.
    for iList = 1 : options.nLists
        listName = ['list_' num2str(choosenLists(iList))];
        if adultsVersion
            words = regexprep(lists(:, choosenLists(iList)), '#','');
            nvaLists.(listName).words2Display = lists(:, choosenLists(iList)); % keep # to split word
        else
            words = regexprep(lists{choosenLists(iList)}, '#','');
            nvaLists.(listName).words2Display = lists{choosenLists(iList)}; % keep # to split word
        end
        % capitalize first letter to make variable sound-file name compatible'
        nvaLists.(listName).wordsLists = ...
            regexprep(words, '(\<[a-z])','${upper($1)}');
        % randomize the word list but the first one
        randomList = randperm(length(words) - 1) + 1;
        nvaLists.(listName).wordsLists( 2:end )  = nvaLists.(listName).wordsLists(randomList);
        nvaLists.(listName).words2Display(2:end) = nvaLists.(listName).words2Display(randomList);
        nvaLists.(listName).TMR = options.TMR(iList);
    end
    
    % check if all words are present, then there should not be the aviread
    % error anymore.
    for iList = 1 : options.nLists
        listName = ['list_' num2str(choosenLists(iList))];
        wordsUp = nvaLists.(listName).wordsLists;
        wavFilesWords = dir([options.wordsFolder '*.wav']);
        % remove noise, it's usually the first one
        wavFilesWords(1) = [];
        for iword = 1 : length(wordsUp)
%             if sum(~cellfun('isempty', strfind({wavFilesWords.name},
%             wordsUp{iword}))) ~= 1 % strfind gives multiple entries for
%             Zin and Zijn
            if sum(strcmp({wavFilesWords.name}, [wordsUp{iword} '.wav'])) ~= 1
                disp([wordsUp{iword} ' ' listName ' has something weird'])
                disp('I will now stop running, please start again')
                stopNow = true;
                return
            end
        end % end words
    end % end list

   
end