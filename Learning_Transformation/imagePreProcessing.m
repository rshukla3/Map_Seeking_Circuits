function [ Test_Img ] = imagePreProcessing( )
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Test_Img = imread('square_3.jpg');

Test_Img_gray = rgb2gray(Read_Test_Img);

[Im, In] = size(Test_Img_gray);

[~, Thresh] = edge(Test_Img_gray, 'prewitt');
Test_Img_BW = edge(Test_Img_gray, 'prewitt', Thresh*0.5);
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Test_Img_dilate = imdilate(Test_Img_BW, [se90 se0]);
Test_Img_Fill = imfill(Test_Img_dilate, 'holes');
seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
Test_Img_Erode = imerode(Test_Img_Final,seD);
BWoutline = edge(Test_Img_Erode);
Test_Img = logical(zeros(Im, In));
Test_Img(BWoutline) = 1;


figure(2);
imshow(Test_Img);

end

