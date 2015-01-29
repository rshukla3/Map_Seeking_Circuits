function [ Test_Img, Test_Img_Erode ] = imagePreProcessing(filename)
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Test_Img = imread(filename);
Read_Test_Img = imnoise(Read_Test_Img,'gaussian',0,0.006);
Test_Img_gray = rgb2gray(Read_Test_Img);

% M = 0;
% V = 0.01;
% Test_Img_gray = imnoise(Test_Img_gray,'gaussian',M,V);
% Scaling = 1.2;
% Test_Img_gray = scaleImg(Test_Img_gray, Scaling, Scaling);
% Rotation = -30;
% Test_Img_gray = single(imrotate(Test_Img_gray, Rotation, 'nearest', 'crop'));
% x_Translation = -100;
% y_Translation = 100;
% Test_Img_gray = translate_img(Test_Img_gray, x_Translation, y_Translation);

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

% Rotation = -30;
% Test_Img_Erode = single(imrotate(Test_Img_Erode, Rotation, 'nearest', 'crop'));
% Scaling = 0.8;
% Test_Img_Erode = scaleImg(Test_Img_Erode, Scaling, Scaling);
% x_Translation = 100;
% y_Translation = -120;
% Test_Img_Erode = translate_img(Test_Img_Erode, x_Translation, y_Translation);

BWoutline = edge(Test_Img_Erode);
Test_Img = logical(zeros(Im, In));
Test_Img(BWoutline) = 1;
Test_Img = single(Test_Img);
%Test_Img = single(imrotate(Test_Img, 45, 'nearest', 'crop'));
%Test_Img = translate_img(Test_Img, 100, -150);
%Test_Img = Test_Img.*255;

%figure(2);
%imshow(Test_Img);

end

