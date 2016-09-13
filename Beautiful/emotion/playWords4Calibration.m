snfDiles = dir(['~/Sounds/Emotion_normalized/*.wav']);
tstart = tic;
for ifile = 1 : length(snfDiles)
    [y, fs] = audioread(['~/Sounds/Emotion_normalized/' snfDiles(ifile).name]);
    p = audioplayer(y, fs);
    playblocking(p);
    telapsed = toc(tstart);
    if telapsed > 90
        break
    end
end


