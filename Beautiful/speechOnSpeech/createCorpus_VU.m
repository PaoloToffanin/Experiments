function createCorpus_VU
% Create 'corpus file' giving the link between filename, 
% sentence, and list number (see [Generic corpus definition]).
% The corpus definition is a text file with the following format:
% List number#Filename#Sentence

    %% list number:
    % 13 sentences x list (2 sexes) to the end of the file with all sentences

    %% filename
    filenames = dir('VU_zinnen/sentences/*wav');

    %% sentences
    load('VU_zinnen.mat') % list of sentences
    who
    class(VU_zinnen)
    size(VU_zinnen)

    % write out to text
    fid = fopen('VU_corpus_definition.txt', 'wt');
    indexList = 1;
    for item = 1 : length(filenames)
        fprintf(fid, '%2d#%s#%s\n', ...
            indexList, ...
            filenames(item).name, ...
            VU_zinnen{item});
        if mod(item, 13) == 0
            indexList = indexList + 1;
        end
    end
    fclose(fid);
    type('VU_corpus_definition.txt')


    % fprintf('%03.0f#\n', indexList)
end