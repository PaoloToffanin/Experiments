% set path differently? 
emotionvoices = dir('../Stimuli/Emotion/Emotion_normalized/*.wav');

%training = (emotionsounds.name(2)=('1'|'3'|'7'|'8'))
% speaker = s1:8;



nFile = length (emotionvoices);

for iFile = 1:nFile 
    switch (emotionvoices(iFile).name(4))
        case '2'
            emotionvoices(iFile).emotion = 'angry'; 
        case '3'
            emotionvoices(iFile).emotion = 'sad';
        case '5'
            emotionvoices(iFile).emotion = 'joyful';
    end 
        
end

emotionvoices = dir('../Stimuli/Emotion/Emotion_normalized/*.wav');

nFile = length (emotionvoices);
counter = 0;
FileIn = [];
voice = [];

for iFile = 1:nFile 
    if any (emotionvoices(iFile).name(4) == 2);
         emotionvoices(iFile)= voice;
    else
        counter = counter + 1;
        FileIn(counter)= iFile; 
    end
end

%%%%%%%%% This one worked sort of
for iFile = 1:nFile 
    if any(emotionvoices(iFile).name(4) == angry);
        voice(iFile) = emotionvoices(iFile) 
    else
        counter = counter + 1;
        FileIn(counter)= iFile; 
    end
end




% emotion = e2 | e3 | e5
angrysound = (emotionvoices.name(4)== 2);
sadness = ['3'];
joyful = ['5'];

angrysound = (emotionvoices(ifile).name(4) == anger)
sadsound = (emotionvoices.name(4) == sadness)
joyfulsound = (emotionvoices.name(4) == joyful)


% utterance = n1:n2
first = ['1']
second = ['2']  

nFile = length(emotionvoices);

counter = 0;
fileIn = [];
for ifile = 1 : nFile;
    if any(emotionvoices(ifile).name(2) == test)
        %files = fileIn 
    else
        counter = counter + 1;
        fileIn(counter) = ifile;
    end
        
end

emotionvoices(fileIn) = [];

length(emotionvoices);

nfiles = length(emotionvoices);
randVect = randperm (24); 

for ifile = 1:nfiles 
    disp (randVect(ifile)) ;
    disp (emotionvoices(randVect(ifile)).name);
    [y, Fs] = audioread (emotionvoices(randVect(ifile)).name);
    player = audioplayer (y, Fs);
    playblocking (player); 
    
    disp(emotionvoices(randVect(ifile)).name)
end

% e = emotion
% 2 % anger;
% 3 % sadness 
% 5 % joy  
% 8 is removed because is relief

% n = utterance








