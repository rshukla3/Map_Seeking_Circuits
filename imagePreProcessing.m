function [ Memory_Img, Test_Img ] = imagePreProcessing( )
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Memory_Img = imread('Green-Bell-Pepper-Memory.jpg');

Read_Test_Img = imread('Peppers.tiff');

Memory_Img_gray = rgb2gray(Read_Memory_Img);
Test_Img_gray = rgb2gray(Read_Test_Img);

%Memory_Img_gray(Memory_Img_gray == 255) = 0;

Level_Memory_Img = graythresh(Memory_Img_gray);
Level_Test_Img = graythresh(Test_Img_gray);

Memory_Img_BW = im2bw(Memory_Img_gray, Level_Memory_Img);
Test_Img_BW = im2bw(Test_Img_gray, Level_Test_Img);

Memory_Img = edge(Memory_Img_BW, 'canny');
Test_Img = edge(Test_Img_BW, 'canny');

figure(1);
imshow(Memory_Img);

figure(2);
imshow(Test_Img);
end

