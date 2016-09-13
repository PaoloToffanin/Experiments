function [options] = MCI_options

    addpath('../lib/MatlabCommonTools/');
    options.locationImages = [getHome '/imagesBeautiful/MCI/Images/'];
    rmpath('../lib/MatlabCommonTools/');
 
    options.locationNotes = 'H:\data\Post-doc\Tests\\piano';
%     [~, name] = system('hostname');
%     if strncmp(name, 'debian', 6)
%         options.locationNotes = '/home/paolot/gitStuff/emotionTaskAngelSound/Gronigen/Stimuli/MCI/';
%     else
        options.locationNotes = '~/Sounds/MCI/';
%     end
    
end