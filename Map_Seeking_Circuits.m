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

% 3. Number of iterations for which Map_Seeking Circuit architecture will
% run.
iterationCount = 1;

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

g_layer1(1:2*xTranslationCount+1) = single(ones(1,2*xTranslationCount+1));

g_layer2(1:2*yTranslationCount+1) = single(ones(1,2*yTranslationCount+1));

g_layer3(1:2*rotationCount+1) = single(ones(1,2*rotationCount+1));

%% %% The number of iterations for MSC to run.
for i = 1:iterationCount
    
%% Set the value of backward path 

    % First initialize the value of backward path in the last layer.
    b4 = Memory_Img;

    % Assign rest of the values for the backward path.

    % Perform inverse rotation on the backward layer.
    b3 = layer_3(b4, rotationCount, rotationQuantity, g_layer3, 'backward');

    % Perform inverse translation on the superimposed image along y-axis.
    b2 = layer_2(b3, yTranslationCount, yTranslateQuantity, g_layer2, 'backward');
    
%% Set the value of q to all zeros for the three layers.

    q_layer1(1:2*xTranslationCount+1) = single(zeros(1,2*xTranslationCount+1));

    q_layer2(1:2*yTranslationCount+1) = single(zeros(1,2*yTranslationCount+1));

    q_layer3(1:2*rotationCount+1) = single(zeros(1,2*rotationCount+1));

%% Perform transformation on the image.

    % Translate the image along x-axis.
    [f1, Tf0] = layer_1(Test_Img, xTranslationCount, xTranslateQuantity, g_layer1, 'forward');
    
    %Calculate the value of q_layer1.
    q_layer1(1:2*xTranslationCount+1) = dotproduct(Tf0, b2);

    % Translate the superimposed image along y-axis.
    [f2, Tf1] = layer_2(f1, yTranslationCount, yTranslateQuantity, g_layer2, 'forward');
    
    %Calculate the value of q_layer2.
    q_layer2(1:2*yTranslationCount+1) = dotproduct(Tf1, b3);

    % Rotate the x-translated and y-translated image.
    [f3, Tf2] = layer_3(f2, rotationCount, rotationQuantity, g_layer3, 'forward');
    
    %Calculate the value of q_layer3.
    q_layer3(1:2*rotationCount+1) = dotproduct(Tf2, b4);

end

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