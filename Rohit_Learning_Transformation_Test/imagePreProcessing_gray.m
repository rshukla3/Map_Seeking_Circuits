function [ Test_Img, Test_Img_gray] = imagePreProcessing_gray(filename)
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.
0
Read_Test_Img = imread(filename);
Read_Test_Img = imnoise(Read_Test_Img,'gaussian',0,0.0);
% Read_Test_Img = imnoise(Read_Test_Img,'salt & pepper',0.01);
[m,n,l] = size(Read_Test_Img);
if l == 3
    Test_Img_gray = rgb2gray(Read_Test_Img);
elseif l == 1
    Test_Img_gray = Read_Test_Img;
else
    fprintf('imagePreProcessing: Image is neither RGB or grayscale\n');
end
[m,n] = size(Test_Img_gray)
if m ~= 512 || n ~= 512
    % Need to perform image padding.
    pm = (512-m)/2;
    pn = (512-n)/2;
    Test_Img_gray = padarray(Test_Img_gray, [pm, pn], 'both');
end
[m,n] = size(Test_Img_gray)
% M = 0;
% V = 0.01;
% Test_Img_gray = imnoise(Test_Img_gray,'gaussian',M,V);
Scaling = 1.2;
Test_Img_gray = scaleImg(Test_Img_gray, Scaling, Scaling);
Rotation =  -15;
Test_Img_gray = (imrotate(Test_Img_gray, Rotation, 'nearest', 'crop'));
x_Translation = 0;
y_Translation = 0;
Test_Img_gray = translate_img_grayScale(Test_Img_gray, x_Translation, y_Translation);
% [m,n] = size(Test_Img_gray);
% M = max(max(Test_Img_gray));
% for i= 1:m
%     for j = 1:n
%         if(Test_Img_gray(i,j) <= 10)
%             Test_Img_gray(i,j) = M;
%         end
%     end
% end


%Test_Img_gray = wiener2(Test_Img_gray,[5 5]);
[Im, In] = size(Test_Img_gray);

[Test_Img_BW, Thresh] = edge(Test_Img_gray, 'prewitt');
Thresh*0.25
figure(20);
imshow(Test_Img_BW);
pause(1);
if(Thresh*0.25 < 0.012)
    Thresh = 0.012;
else 
    Thresh = Thresh*0.205;
end
Test_Img_BW = edge(Test_Img_gray, 'prewitt', Thresh);
figure(21);
imshow(Test_Img_BW);
pause(1);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Test_Img_dilate = imdilate(Test_Img_BW, [se90 se0]);
Test_Img_Fill = imfill(Test_Img_dilate, 'holes');
seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
Test_Img_Erode = imerode(Test_Img_Final,seD);
% Test_Img_Erode = bwareaopen(Test_Img_Erode,200);
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

figure(20);
imshow(Test_Img);
pause(1);
end

