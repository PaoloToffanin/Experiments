function [options] = emotion_options

    addpath('../lib/MatlabCommonTools/');
    options.locationImages = [getHome '/imagesBeautiful/emotion/Images/'];
    rmpath('../lib/MatlabCommonTools/');
 
end