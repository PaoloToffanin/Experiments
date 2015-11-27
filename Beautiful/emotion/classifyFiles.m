function emotionvoices = classifyFiles(soundDir, phase)

% set path differently? 
% emotionvoices = dir([soundDir '*.wav']);

emotionvoices(1).name = 's2e2n4.wav';
emotionvoices(2).name = 's2e3n2.wav';
emotionvoices(3).name = 's2e5n1.wav';
emotionvoices(4).name = 's4e2n3.wav';
emotionvoices(5).name = 's4e3n1.wav';
emotionvoices(6).name = 's4e5n1.wav';
emotionvoices(7).name = 's5e2n1.wav';
emotionvoices(8).name = 's5e3n1.wav';
emotionvoices(9).name = 's5e5n1.wav';
emotionvoices(10).name = 's6e2n4.wav';
emotionvoices(11).name = 's6e3n1.wav';
emotionvoices(12).name = 's6e5n4.wav';

if strcmp(phase, 'training')
    emotionsounds = dir([soundDir '*.wav']);
%     training = (emotionsounds.name(2)=('1'|'3'|'7'|'8'))
%     training = {emotionsounds(~cellfun('isempty', ...
%         regexp({emotionsounds.name}, '^s[1378]'))).name};
    emotionvoices = emotionsounds(~cellfun('isempty', regexp({emotionsounds.name}, '^s[1378]')));
    
end    
%training = (emotionsounds.name(2)=('1'|'3'|'7'|'8'))
% speaker = s1:8;


nFile = length (emotionvoices);

for iFile = 1 : nFile 
    switch (emotionvoices(iFile).name(4))
        case '2'
            emotionvoices(iFile).emotion = 'angry'; 
        case '3'
            emotionvoices(iFile).emotion = 'sad';
        case '5'
            emotionvoices(iFile).emotion = 'joyful';
    end 
    switch (emotionvoices(iFile).name(2))
        case {'2', '4', '5', '6'}
            emotionvoices(iFile).phase = 'test'; 
        case {'1', '3', '7', '8'}
            emotionvoices(iFile).phase = 'training';
    end 
 
 
end


    

