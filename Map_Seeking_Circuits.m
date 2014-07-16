clear all;
close all;
clc;

%% Setting up the parameters.

% 1. Set the parameters for image translation.

% By how much the image should be translated on x-axis.
xTranslateQuantity = 90;

% By how much the image should be translated on y-axis.
yTranslateQuantity = 110;

% Number of times this translation that has to be applied.
translationCount = 15;

% 2. Set the parameters for image rotation.

% This term defines the number of times input image should be rotated
rotationCount = 15;

% The precision by which image should be rotated.
rotationQuantity = 1.5;

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

xyTanslated_Img = layer_1(Test_Img, translationCount, xTranslateQuantity, yTranslateQuantity);

rotated_img = layer_2(xyTanslated_Img, rotationCount, rotationQuantity);

figure(1);
imshow(xyTanslated_Img);

figure(2);
imshow(rotated_img);