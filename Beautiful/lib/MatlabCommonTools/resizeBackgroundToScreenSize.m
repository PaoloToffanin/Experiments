function img = resizeBackgroundToScreenSize(screenSize, bkgName)
%function img = resizeBackgroundToScreenSize(screenSize, bkgName)

    fprintf('Resizing background to screen size...');
    screenHeigth = screenSize(4); % assuming 10 pixels are enough to cover the menu
    screenWidth = screenSize(3);
    %[X, ~, ~] = imread('BACKGROUND_unscaled.png');    
    
    % determine whether the rescaled background file already exists in the
    % proper dimensions.
    
    underscore = strfind(bkgName, '_');
    nameFile = [bkgName(1 : underscore), bkgName(underscore + 3 : end)];
    rescaleScreen = true;
    if exist(nameFile, 'file')
        [img] = imread(nameFile);
        [heigthPic, ~, ~] = size(img); % only heigth picture and height screen will match since bkg is scrolling picture width is always larger than screen length
        if heigthPic == screenHeigth
            rescaleScreen = false;
        end
    end
        
    if rescaleScreen
        clear img
        [X] = imread(bkgName);
        [heigthPic, widthPic, ~] = size(X);
        
        Y = zeros(screenHeigth, widthPic, 3);
        
        for heigthRGB = 1 : 3
            Y(:, :, heigthRGB) = resample(double(squeeze(X(:, :, heigthRGB))), screenHeigth, heigthPic);
        end
        
        LengthScreen = screenWidth;
        if screenWidth < widthPic
            ScreenRepetitions = widthPic/1600; % 1600 is the original screen Width for which pictures were drawn
            LengthScreen = round(ScreenRepetitions * screenWidth);
        end
        
        Y1 = zeros(LengthScreen, screenHeigth, 3);
        % Y = Y'; = transpose matrice so that the second dimension can be interpolated too;
        Ytransp = zeros(size(Y, 2), size(Y, 1), 3);
        for irgb = 1 : 3
            Ytransp(:, :, irgb) = Y(:, :, irgb)';
        end
        
        for widthRGB =  1:3
            Y1(:, :, widthRGB) = resample(Ytransp(:, :, widthRGB), LengthScreen, widthPic);
        end
        
        % Yretransp = zeros(screenWidth, screenHeigth, 3);
        Yretransp = zeros(screenHeigth, LengthScreen, 3);
        for irgb = 1 : 3
            Yretransp(:, :, irgb) = Y1(:, :, irgb)';
        end
        
        % Y1 = Y1'; % transpose the matrix back to its original shape
        img = uint8(Yretransp); % image must have unsigned 8 bit integer values
        imwrite(img,nameFile);
        
    end
    fprintf(' resizing done!!\n');
end