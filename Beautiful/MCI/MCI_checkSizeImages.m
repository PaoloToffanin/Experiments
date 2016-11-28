dirImgs = '~/imagesBeautiful/MCI/Images/';
listImgs = dir([dirImgs '*.jpg']);
nImages = length(listImgs);
height = zeros(1, nImages);
weigth = zeros(1, nImages);
for imgs = 1 : nImages
    [height(imgs), width(imgs)] = size(imread([dirImgs, listImgs(imgs).name]));
end

max(height)
min(height)
max(width)
min(width)


