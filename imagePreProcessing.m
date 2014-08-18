function [ Memory_Img, Test_Img ] = imagePreProcessing( )
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Memory_Img = imread('Green-Bell-Pepper-1.jpg');

Read_Memory_Img(:, 366:512,:) = 255;

Read_Test_Img = imread('Peppers.tiff');

Memory_Img_gray = rgb2gray(Read_Memory_Img);
Test_Img_gray = rgb2gray(Read_Test_Img);

h = fspecial('gaussian', size(Test_Img_gray), 2.5);

Test_Img_gray = imfilter(Test_Img_gray, h);

%Memory_Img_gray(Memory_Img_gray == 255) = 0;

Level_Memory_Img = graythresh(Memory_Img_gray);
Level_Test_Img = graythresh(Test_Img_gray);

Memory_Img_BW = im2bw(Memory_Img_gray, Level_Memory_Img);
Test_Img_BW = im2bw(Test_Img_gray, Level_Test_Img);

Memory_Img = edge(Memory_Img_BW, 'canny');
Test_Img_Canny = edge(Test_Img_BW, 'canny');

D = bwdist(Test_Img_Canny);

%h = fspecial('gaussian', size(Test_Img_Canny), 0.1);

% Test_Img = imfilter(Test_Img_Canny, h);

Test_Img = Test_Img_Canny&(D<1);

% Fill closed objects:
%Test_Img_Holes = imfill(Test_Img_Canny , 'holes');
% Get rid of objects less than 500 pixels:
%Test_Img = bwareaopen(Test_Img_Holes, 0);

figure(1);
imshow(Memory_Img);

figure(2);
imshow(Test_Img);

%figure(3);
%imshow(blurredImage);
end

