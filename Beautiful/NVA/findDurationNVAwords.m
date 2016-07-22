files = dir('/home/paolot/sounds/NVA/individualWords/*.wav');
maxDur = 0;
nFiles = length(files);
for ifile = 1 : nFiles
    tmp = audioinfo(['/home/paolot/sounds/NVA/individualWords/' files(ifile).name]);
    if (maxDur < tmp.Duration)
        maxDur = tmp.Duration;
    end
end

disp(maxDur)