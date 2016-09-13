function createCorpus
% Create 'corpus file' giving the link between filename, 
% sentence, and list number (see [Generic corpus definition]).
% The corpus definition is a text file with the following format:
% List number#Filename#Sentence

%% could also be:
% run('defineParticipantDetails.m')

%% instead of
participant.sentencesCorpus = 'VU_zinnen';
%  participant.sentencesCorpus = 'plomp';

%% list number:
% for the VU
% 13 sentences x list (2 sexes) to the end of the file with all sentences
% for the plomp

%% filename
% filenames = dir('VU_zinnen/sentences/*wav');
filenames = dir(['~/sounds/' participant.sentencesCorpus '/sentences/*wav']);

%% sentences
%  fidOut = fopen(['~/sounds/' participant.sentencesCorpus '/corpusDefinitionCris.txt'], 'wt');
fidOut = fopen(['~/sounds/' participant.sentencesCorpus '/corpusDefinition.txt'], 'wt');
switch participant.sentencesCorpus
    case 'VU_zinnen'
        load(['~/sounds/' participant.sentencesCorpus '/VU_zinnen.mat']) % list of sentences
        indexList = 1;
        for item = 1 : length(filenames)
            writeOutLines(fidOut, indexList, filenames(item).name, VU_zinnen{item});
            if mod(item, 13) == 0
                indexList = indexList + 1;
            end
        end
    case 'plomp'
        fidIn = fopen(['~/sounds/' participant.sentencesCorpus '/00 plomp list.txt'], 'rt');
        indexList = 0;
        item = 0;
        while ~feof(fidIn)
            tline = fgetl(fidIn);
            % skip empty lines
            while isempty(tline) 
                tline = fgetl(fidIn);
            end
            if strfind(tline, 'List')
                indexList = indexList + 1;
                tline = fgetl(fidIn); % get next line
            end
            out = regexp(tline, '\d+\s', 'split'); % remove numbers followd by space
            item = item + 1;
            writeOutLines(fidOut, indexList, filenames(item).name, out{2})
            
        end
end
fclose(fidOut);
fprintf('flie written to:\n%s\n', ...
    ['~/sounds/' participant.sentencesCorpus '/corpusDefinition.txt']);
% type(['~/sounds/' participant.sentencesCorpus '/corpusDefinition.txt'])


% fprintf('%03.0f#\n', indexList)

end

function writeOutLines(fidOut, indexList, name, out)
% this function is created for consistency among different corpuses

%      fprintf(fidOut, '%2d#%s#%s# %d\n', indexList, name, out,...
%  			length(regexp(out, '\s', 'split')));
    fprintf(fidOut, '%2d#%s#%s\n', indexList, name, out);
end
