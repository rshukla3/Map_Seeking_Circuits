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

J = translate_img(Memory_Img, -150, 150);

figure(1);
imshow(Memory_Img);

figure(2);
imshow(Test_Img);

figure(3);
imshow(J);
