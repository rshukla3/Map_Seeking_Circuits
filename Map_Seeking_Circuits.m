clear all;
close all;
clc;

%% Setting up the parameters.

% 1. Set the parameters for image translation.

% By how much the image should be translated on x-axis.
xTranslateQuantity = 90;

% By how much the image should be translated on y-axis.
yTranslateQuantity = 110;

% Number of times this x-translation that has to be applied.
xTranslationCount = 2;

% Number of times this x-translation that has to be applied.
yTranslationCount = 2;

% 2. Set the parameters for image rotation.

% This term defines the number of times input image should be rotated
rotationCount = 1;

% The precision by which image should be rotated.
rotationQuantity = 45;

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
%Test_Img = im2bw(Test_Img_gray, Level_Test_Img);

Test_Img = imrotate(Memory_Img, 45, 'nearest', 'crop');

clear Read_Memory_Img;
clear Read_Test_Img;

clear Memory_Img_gray;
clear Test_Img_gray;

%% Initialize the value of g to all ones for the three layers.

g_layer1(1:2*xTranslationCount) = single(ones(1,2*xTranslationCount));

g_layer2(1:2*yTranslationCount) = single(ones(1,2*yTranslationCount));

g_layer3(1:2*rotationCount) = single(ones(1,2*rotationCount));

%% Set the value of backward path 

% First initialize the value of backward path in the last layer.
b4 = Memory_Img;

% Assign rest of the values for the backward path.

% Perform inverse rotation on the backward layer.
b3 = layer_3(b4, rotationCount, rotationQuantity, g_layer3, 'backward');

% Perform inverse translation on the superimposed image along y-axis.
b2 = layer_2(b3, yTranslationCount, yTranslateQuantity, g_layer2, 'backward');

%% Perform transformation on the image.

% Translate the image along x-axis.
f1 = layer_1(Test_Img, xTranslationCount, xTranslateQuantity, g_layer1, 'forward');

% Translate the superimposed image along y-axis.
f2 = layer_2(f1, yTranslationCount, yTranslateQuantity, g_layer2, 'forward');

% Rotate the x-translated and y-translated image.
f3 = layer_3(f2, rotationCount, rotationQuantity, g_layer3, 'forward');

figure(1);
imshow(f1);

figure(2);
imshow(f2);

figure(3);
imshow(f3);

figure(4);
imshow(b2);

figure(5);
imshow(b3);

figure(6);
imshow(b4);