function [options] = MCI_options

    addpath('../lib/MatlabCommonTools/');
    options.locationImages = [getHome '/imagesBeautiful/MCI/Images/'];
    rmpath('../lib/MatlabCommonTools/');
 
end