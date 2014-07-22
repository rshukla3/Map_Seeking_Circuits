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

Memory_Img_gray = rgb2gray(Read_Memory_Img);
Test_Img_gray = rgb2gray(Read_Test_Img);

Level_Memory_Img = graythresh(Memory_Img_gray);
Level_Test_Img = graythresh(Test_Img_gray);

Memory_Img = im2bw(Memory_Img_gray, Level_Memory_Img);
Test_Img = im2bw(Test_Img_gray, Level_Test_Img);

clear Read_Memory_Img;
clear Read_Test_Img;

clear Memory_Img_gray;
clear Test_Img_gray;

%% Initialize the value of g to all ones for the two layers.

% IMPORTANT: g values for layer_1 (or the translation layer), is divided
% into two parts. First part, i.e., from 1 to translationCount, conatins
% the value of g for translation in positive x direction and positive y
% direction. Second part, i.e., from translationCount to 2*translationCount, conatins
% the value of g for translation in negative x direction and negative y
% direction.

g_layer1(1:2*translationCount) = single(ones(1,2*translationCount));

g_layer2(1:rotationCount) = single(ones(1,rotationCount));

%% First perform x-translation

[M1, M2] = size(Memory_Img);

xyTanslated_Img = layer_1(Test_Img, translationCount, xTranslateQuantity, yTranslateQuantity, g_layer1);

rotated_img = layer_2(xyTanslated_Img, rotationCount, rotationQuantity, g_layer2);

figure(1);
imshow(xyTanslated_Img);

figure(2);
imshow(rotated_img);