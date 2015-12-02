
% options.subject_name = 'Jacquelien';
% options.subject_name = 'paolo';
options.subject_name = 'test';
options.age = 24;
options.sex = 'f';
options.language = 'Dutch'; % English or Dutch
options.kidsOrAdults = 'Kid'; % we leave empty for kids because I am not sure whether we'd fuck up some file names/if statements
if options.age > 18
    options.kidsOrAdults = 'Adult';
end


addpath('lib/MatlabCommonTools/');
options.home = getHome;
rmpath('lib/MatlabCommonTools/');

