clear all;
close all;
clc;

%% Read the image that is to be stored in memory.

Read_Memory_Img = imread('Memory_Img_small_Rectangle.jpg');

%% Read the test image that is to be recognized against the image stored in memory.

Read_Test_Img = imread('Test_Img_Rotated_Rectangle.jpg');

%% Convert he two images to grayscale.

Memory_Img = rgb2gray(Read_Memory_Img);
Test_Img = rgb2gray(Read_Test_Img);

clear Read_Memory_Img;
clear Read_Test_Img;

%% Perform translation on the test image.

% J = translate_img(Memory_Img, -150, 150);
% 
% figure(1);
% imshow(Memory_Img);
% 
% figure(2);
% imshow(Test_Img);
% 
% figure(3);
% imshow(J);

%% First perform x-translation

[M1, M2] = size(Memory_Img);

%xTranslate_sum = zeros(M1, M2);

xTranslate_sum = Test_Img;

translate = 10;
for i = 1:15
    xT = (i*80)+translate;
    
    xTranslate_sum = xTranslate_sum + translate_img(Test_Img, -xT, 0);
    
    xTranslate_sum = xTranslate_sum + translate_img(Test_Img, xT, 0);
end

figure(1);
imshow(xTranslate_sum);

yTranslate_sum = xTranslate_sum;

superposition_Img_xTranslate = xTranslate_sum;
for i = 1:10
    yT = (i*100)+translate;
    
    yTranslate_sum = yTranslate_sum + translate_img(superposition_Img_xTranslate, 0, -yT);
    
    yTranslate_sum = yTranslate_sum + translate_img(superposition_Img_xTranslate, 0, yT);
end

figure(2);
imshow(yTranslate_sum);
