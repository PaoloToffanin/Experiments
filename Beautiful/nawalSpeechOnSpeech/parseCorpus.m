function corpus = parseCorpus(options)
    
    item = 1;
    fid = fopen(options.sentences_file, 'rt');
    while ~feof(fid)
       tline = fgetl(fid);
       if ~isempty(strfind(tline, options.targetSex))
           % tokenize tline
           hashTags = strfind(tline, '#');
           corpus(item).fileIndex = str2double(tline(1 : hashTags(1) - 1)); 
           corpus(item).wavfile = tline(hashTags(1) + 1 : hashTags(2) - 1);
           corpus(item).sentence = tline(hashTags(2) + 1 : end);
           item = item + 1;
       end
    end
    
    fclose(fid);

end