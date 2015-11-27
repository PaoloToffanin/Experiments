function rng(seed)

%rand('state', seed);

warning('off', 'MATLAB:RandStream:SetDefaultStream');

switch seed
    case 'shuffle'
% paol8 edit: RandStream.setDefaultStream(RandStream('mt19937ar','Seed',sum(clock*100)));
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(clock*100)));
    otherwise
% paol8 edit: RandStream.setDefaultStream(RandStream('mt19937ar','Seed',seed));
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed));
end



