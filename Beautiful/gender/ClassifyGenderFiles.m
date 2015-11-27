function gendervoices = ClassifyGenderFiles(soundDir)

gendervoices = dir([soundDir '*.wav']);
% filename = 01NVA01_F0_3_SEx081.wav (= example) 
nFile = length (gendervoices);

gendervoices.f0 = [0 6 12];
gendervoices.ser = [100 96 84 81];

for iFile = 1:nFile 
    switch (gendervoices(iFile).name(7))
        case '1'
            gendervoices(iFile).word = 'bus'; 
        case '2'
            gendervoices(iFile).word = 'vaak';
        case '3'
            gendervoices(iFile).word = 'leeg';
        case '4'
            gendervoices(iFile).word = 'pen';
    end 
    
end


    

