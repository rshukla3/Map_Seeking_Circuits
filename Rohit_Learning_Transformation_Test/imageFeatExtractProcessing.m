function [ Test_Img ] = imageFeatExtractProcessing(inputImg)
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.



Test_Img = imfill(inputImg, 'holes');


end

