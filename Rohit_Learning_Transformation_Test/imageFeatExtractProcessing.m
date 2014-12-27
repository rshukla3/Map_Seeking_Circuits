function [ Test_Img ] = imageFeatExtractProcessing(inputImg)
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.


se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Test_Img_dilate = imdilate(inputImg, [se90 se0]);
Test_Img = imfill(Test_Img_dilate, 'holes');


end

