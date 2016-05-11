function [expe, options] = expe_build_conditions(options)
% Creates the options and expe structs. Those contain all conditions and
% params that are needed for the experiment.

%% ----------- Create Instructions
options.instructions.start = ['Wij willen uw begrip van spraak in de aanwezigheid van een andere spreker testen. De doelzin die u moet '...
     'herhalen zal een halve seconde na de maskerende spreker beginnen. De achtergrondconversatie bestaat uit geknipte '... 
     'woorden die niet moeten kloppen. Uw taak is om de doelzin te herhalen. Uw gesproken antwoorden worden opgenomen voor '...
     'verdere analyse.\n'...
     '-------------------------------------------------\n\n'];
options.instructions.training1 = ['U zult nu luisteren naar alleen de doelspreker om kennis te maken met de manier waarop hij/zij klinkt.\n'...
    'Herhaal alstublieft de zin.\n'...
    '-------------------------------------------------\n\n'];
options.instructions.training2 = ['U zult nu luisteren naar voorbeelden van ZOWEL de beoogde spreker EN de maskerende spreker om te wennen aan de taak.\n'...
    'Alstublieft herhaal de doelzin.\n\n'...
    '-------------------------------------------------\n\n'];
options.instructions.test = ['U zult nu beginnen met de werkelijke test. De doelzin die u moet herhalen zal een halve seconde na de maskerende spreker '...
    'beginnen. De achtergrondconversatie bestaat uit geknipte woorden die niet moeten kloppen. Uw taak is om de'...
    'doelzin te herhalen. Uw gesproken antwoorden worden opgenomen voor verdere analyse.\n'...
    '-------------------------------------------------\n\n'];
options.instructions.listen = ['Luister goed naar de doelzin.\n'...
    '-------------------------------------------------\n\n'];
options.instructions.repeat = ['Herhaal alstublieft de zin.\n'...
    '-------------------------------------------------\n\n'];
options.instructions.feedback = ['Dit is de correcte zin.\n'...
    '-------------------------------------------------\n\n'];
options.instructions.end = ['Gefeliciteerd!! Deze sessie is voorbij. Dank u voor uw deelname.\n'...
    '-------------------------------------------------\n\n'];
options.instructions.breaktime = ['En nu is het tijd voor 5 minuten pauze. Laat alles achter zoals het is.\n'...
    'Wanneer u klaar bent om verder te gaan, kunt u hieronder klikken op de knop "DOORGAAN".\n'...
    '-------------------------------------------------\n\n'];



test_machine = is_test_machine();

if test_machine %If it's computer in Tinnitus Room
    disp('-------------------------');
    disp('--- In Tinnitus Room ---');
    disp('-------------------------');
    options.sound_path = '/Users/dbaskent/Sounds/VU_zinnen/Vrouw/equalized';
    options.tmp_path   = '/Users/dbaskent/Sounds/VU_zinnen/Vrouw/processed';

else %If it's experimenter's OWN computer:
    disp('-------------------------');
    disp('--- On coding machine ---');
    disp('-------------------------');
    options.sound_path = '~/Library/Matlab/Sounds/VU_zinnen/Vrouw/equalized';
    options.tmp_path   = '~/Library/Matlab/Sounds/VU_zinnen/Vrouw/processed';
end

%% ----------- Signal options
options.fs = 44100;
if test_machine
    options.attenuation_dB = 3; % General attenuation
else
    options.attenuation_dB = 3; % General attenuation
end
options.ear = 'both'; % right, left or both

%% ----------- Stimuli options

options.test.f0s  = [0, 4, 9, 12]; 
options.test.vtls = [0, 4, 9, 12];

i_voices = 1;

for i_f0 = 1:length(options.test.f0s)
    
    for i_vtl = 1:length(options.test.vtls)
        
        if (options.test.f0s(i_f0) == 0) && (options.test.vtls(i_vtl) == 0)
            options.test.voices(i_voices).label = 'female';
        else
            options.test.voices(i_voices).label = ['f0-' num2str(options.test.f0s(i_f0)) '-vtl-' num2str(options.test.vtls(i_vtl))];
        end
        
        options.test.voices(i_voices).f0 = 2^(options.test.f0s(i_f0)/12);
        options.test.voices(i_voices).ser = 2^(options.test.vtls(i_vtl)/12);
        
        i_voices = i_voices + 1;
    end
    
end

%--- Voice pairs
% [ref_voice, dir_voice]
options.test.voice_pairs = [ones(length(options.test.voices),1), (1:length(options.test.voices))'];

%--- Define training voices:
% F0 = 8 ST, VTL = 8 ST
options.training.voices(1).label = 'f0-8-vtl-8';
options.training.voices(1).f0 = 2^(8/12); 
options.training.voices(1).ser = 2^(8/12);
options.training.nsentences = 6; %number of training sentences per condition.
options.training.TMR = 12; %dB
options.training.voice_pairs = [ones(length(options.training.voices),1), (1:length(options.training.voices))'];
%% --- Define sentence bank for each stimulus type:

%1. Define the lists:
options.sentence_bank = 'VU_zinnen_vrouw.mat';  %Where all sentences in the vrouw database are stored as string.
options.list = {''};
[~,name,~] = fileparts(options.sentence_bank);
sentences = load(options.sentence_bank,name);
sentences = sentences.(name);


for i = 1:13:length(sentences)
    if i == 1
        options.list{end} = [i i+12];
    else
        options.list{end+1} = [i i+12];
    end
end

%2. Define the sentence bank for each stimulus type:
options.trainSentences = 14;            %indices of training lists (target)
options.testS1 = [1:12 15:18];                     %indices of test lists Session 1 (target)
options.testS2 = options.testS1;                    %indices of test lists Session 2 (target)
options.masker = [13 21 39];                    %masker sentences training+test all sessions

    
%--- No vocoding should be used:
options.vocoder = 0;

%--- Define Target-to-Masker Ratio in dB:
options.TMR = 8; %testing at 8dB
%This protocol was adopted from Mike and Nikki's Musician effect on SOS
%performance; TMR values taken from Pals et al. 2015, and Stickney et al.
%2004

%--- Define number of breaks throughout the experiment:
options.nbreaks = 4;

%% Build Experimental Conditions:

rng('shuffle');

%================================================== Build training block
training = struct();

%3. Define the training sentences:
trainList = datasample(options.trainSentences,1); %Randomly select a list
trainseq = datasample(options.list{trainList}(1):options.list{trainList}(2),options.training.nsentences*2,'Replace',false); %Randomly select n*2 sentences from the list

training.training1.sentences = [trainseq(1:options.training.nsentences)];
training.training2.sentences = [trainseq(options.training.nsentences+1:end)];
training.train_list = trainList;

training.ref_voice = options.training.voice_pairs(1, 1);
training.dir_voice = options.training.voice_pairs(1, 2);
training.TMR = options.training.TMR;
training.feedback = 1;

expe.training = training;


%================================================== Build test block

test = struct();

for session = 1
    
    i_condition = 1; %count the number of conditions needed
    
    rnd_voice_pairs = randperm(size(options.test.voice_pairs, 1));
    
    
    %2. Randomize the test list order:
    n_session = ['testS' num2str(session)];   
    testList = options.(n_session);

    rand_testList = datasample(testList,length(testList),'Replace',false); %shuffle the order of the test lists
    
    
        
        for i_vp = rnd_voice_pairs
                
            ind_testList = rand_testList(i_condition);
            test_sentences = options.list{ind_testList}(1):options.list{ind_testList}(2);
            
            %Randomize the test sentences within a list:
            test_sentences = datasample(test_sentences,length(test_sentences),'Replace',false);
            
            for i_sent = test_sentences

                condition = struct();

                condition.session = session;
                condition.vocoder = options.vocoder;

                condition.TMR = options.TMR;

                condition.test_sentence = i_sent;
                condition.test_list = ind_testList;

                condition.ref_voice = options.test.voice_pairs(i_vp, 1);

                condition.dir_voice = options.test.voice_pairs(i_vp, 2);


                condition.done = 0;

                condition.visual_feedback = 0;


                if ~isfield(test,'conditions')
                    test.conditions = condition;
                else
                    test.conditions(end+1) = condition;
                end

            end

            i_condition = i_condition+1; %increment the counter.
        end
        
end

%Randomize all:
test.conditions = test.conditions(randperm(length(test.conditions)));
%====================================== Create the expe structure and save

expe.test = test;

%--
                
if isfield(options, 'res_filename')
    save(options.res_filename, 'options', 'expe');
    
else
    warning('The test file was not saved: no filename provided.');
end




