clear 

ScreenSize = get(0, 'MonitorPositions');
screenHeigth = ScreenSize(1, 4);
screenWidth = ScreenSize(1, 3);

% test whether it works with other dimensions than screen size
% screenHeigth = 2000 ;
% screenWidth = 4000;

[X,map,alpha] = imread('BACKGROUND_unscaled.png');
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
Y2 = uint8(Yretransp); % image must have unsigned 8 bit integer values
imwrite(Y2,'BACKGROUND_scaled.png'); % 