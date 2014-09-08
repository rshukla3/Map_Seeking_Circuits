clc;
clear all;
close all;

%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Test_Img = imread('pepper_5.jpg');

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
Test_Img = single(Test_Img);

xTranslate = 0;
yTranslate = 0;
index = 1;
while(yTranslate < 340)
    xTranslate = 0;
    while(xTranslate  < 380)
        Test_Img_xTranslate = translate_img(Test_Img, xTranslate, 0);
        Test_Img_yTranslate = translate_img(Test_Img_xTranslate, 0, yTranslate);
        Movie_Img(:,:,index) = Test_Img_yTranslate;
        xTranslate = xTranslate + 20;
    end
    yTranslate = yTranslate + 20;
end

save('Movie_Matrix.mat', 'Movie_Img');


