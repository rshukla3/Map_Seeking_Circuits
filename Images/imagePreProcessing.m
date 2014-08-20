function [ Memory_Img, Test_Img ] = imagePreProcessing( )
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Memory_Img = imread('alarm_clock_test.png');

%Read_Memory_Img = scaleImg(Read_Memory_Img, 100, 100);

%Read_Test_Img = imread('M-36_tank_destroyer_crosses_a_field_resize.jpg');

%Read_Test_Img = scaleImg(Read_Test_Img, 100, 100);
Memory_Img_gray = Read_Memory_Img;
%Memory_Img_gray = rgb2gray(Read_Memory_Img);
%Test_Img_gray = rgb2gray(Read_Test_Img);
%Test_Img_gray = Read_Test_Img;

h = fspecial('gaussian', size(Memory_Img_gray), 1.0);
Memory_Img_gray = imfilter(Memory_Img_gray, h);

%h = fspecial('gaussian', size(Memory_Img_gray), 1.5);
%Memory_Img_gray = imfilter(Memory_Img_gray, h);

%Memory_Img_gray(Memory_Img_gray == 255) = 0;

Level_Memory_Img = graythresh(Memory_Img_gray);
%Level_Test_Img = graythresh(Test_Img_gray);

Memory_Img_BW = im2bw(Memory_Img_gray, Level_Memory_Img);
%Test_Img_BW = im2bw(Test_Img_gray, Level_Test_Img);

Memory_Img = edge(Memory_Img_BW, 'canny');
%Test_Img_Canny = edge(Test_Img_BW, 'canny');

%D = bwdist(Test_Img_Canny);

%h = fspecial('gaussian', size(Test_Img_Canny), 0.1);

% Test_Img = imfilter(Test_Img_Canny, h);

%Test_Img = Test_Img_Canny&(D<1);

% Fill closed objects:
%Test_Img_Holes = imfill(Test_Img_Canny , 'holes');
% Get rid of objects less than 500 pixels:
%Test_Img = bwareaopen(Test_Img_Holes, 0);
%Memory_Img(311:410,:)=0;
figure(1);
imshow(Memory_Img);

%figure(2);
%imshow(Test_Img);

%figure(3);
%imshow(blurredImage);
end

