clear all;
close all;
clc;

%% Setting up the parameters.

% 1. Set the parameters for image translation.

% By how much the image should be translated on x-axis.
xTranslateQuantity = 90;

% By how much the image should be translated on y-axis.
yTranslateQuantity = 90;

% Number of times this x-translation that has to be applied.
xTranslationCount = 4;

% Number of times this x-translation that has to be applied.
yTranslationCount = 4;

% 2. Set the parameters for image rotation.

% This term defines the number of times input image should be rotated
rotationCount = 2;

% The precision by which image should be rotated.
rotationQuantity = 45;

% 3. Number of iterations for which Map_Seeking Circuit architecture will
% run.
iterationCount = 20;

% 4. Set the value of constants k, for multiplication with g.

k_xTranslation = 0.5;
k_yTranslation = 0.5;
k_rotation = 0.3;
k_scaling = 0.3;
k_mem = 0.7;

% 5. Select the value of gThresh or threshold value of g.
gThresh = 0.3;

% 6. Parameters for scaling the image.

% Number of times scaling is applied on the image.
scaleCount = 1;

% Factor by which each time an image is scaled.
scaleFactor = 0.1;

% 7. Number of elements that are present in the memory unit.

memory_units = 2;

%% Read the image that is to be stored in memory.

Read_Memory_Img = imread('Memory_Img_small_Rectangle.jpg');
Read_Memory_Img_1 = imread('Memory_Img_small_Circle.jpg');

%% Read the test image that is to be recognized against the image stored in memory.

Read_Test_Img = imread('Test_Img_Rotated_Rectangle.jpg');

%% Convert he two images to grayscale.

Memory_Img_gray = rgb2gray(Read_Memory_Img);
Memory_Img_gray_1 = rgb2gray(Read_Memory_Img_1);
Test_Img_gray = rgb2gray(Read_Test_Img);

Level_Memory_Img = graythresh(Memory_Img_gray);
Level_Memory_Img_1 = graythresh(Memory_Img_gray_1);
Level_Test_Img = graythresh(Test_Img_gray);

Memory_Img = im2bw(Memory_Img_gray, Level_Memory_Img);
Memory_Img_1 = im2bw(Memory_Img_gray, Level_Memory_Img_1);
Test_Img = im2bw(Test_Img_gray, Level_Test_Img);

%Test_Img_Rotated = imrotate(Memory_Img, 45, 'nearest', 'crop');

%Test_Img = translate_img(Test_Img_Rotated, -300, -300);

clear Read_Memory_Img;
clear Read_Memory_Img_1;
clear Read_Test_Img;

clear Memory_Img_gray;
clear Memory_Img_gray_1;
clear Test_Img_gray;

%% Initialize the value of g to all ones for the three layers.

g_layer1(1:2*xTranslationCount+1) = single(ones(1,2*xTranslationCount+1));

g_layer2(1:2*yTranslationCount+1) = single(ones(1,2*yTranslationCount+1));

g_layer3(1:2*rotationCount+1) = single(ones(1,2*rotationCount+1));

g_layer4(1:2*scaleCount+1) = single(ones(1,2*scaleCount+1));

g_mem(1:memory_units) = single(ones(1,memory_units));


%% %% The number of iterations for MSC to run.
for i = 1:iterationCount
    
%% Set the value of backward path 

    % First initialize the value of backward path in the last layer.
    b5 = g_mem(1)*Memory_Img + g_mem(2)*Memory_Img_1;

    % Assign rest of the values for the backward path.
    
     % Perform inverse scaling on the backward layer.
    [b4, Tf_tmp, q_layer4_scaling] = layer_4(b5, scaleCount, scaleFactor, g_layer4, 'backward');

    % Perform inverse rotation on the backward layer.
    b3 = layer_3(b4, rotationCount, rotationQuantity, g_layer3, 'backward');

    % Perform inverse translation on the superimposed image along y-axis.
    b2 = layer_2(b3, yTranslationCount, yTranslateQuantity, g_layer2, 'backward');
    
    % Perform inverse translation on the superimposed image along y-axis.
    b1 = layer_1(b2, xTranslationCount, xTranslateQuantity, g_layer1, 'backward');
    
%% Set the value of q to all zeros for the three layers.

    q_layer1(1:2*xTranslationCount+1) = single(zeros(1,2*xTranslationCount+1));

    q_layer2(1:2*yTranslationCount+1) = single(zeros(1,2*yTranslationCount+1));

    q_layer3(1:2*rotationCount+1) = single(zeros(1,2*rotationCount+1));
    
    q_layer4(1:2*scaleCount+1) = single(zeros(1,2*scaleCount+1));
    

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
    
     % Scale the rotated image.
    [f4, Tf3] = layer_4(f3, scaleCount, scaleFactor, g_layer4, 'forward');
    
    %Calculate the value of q_layer4, or the layer that performs scaling operation.
    q_layer4(1:2*scaleCount+1) = dotproduct(Tf3, b5);
    
    q_layer4(1:2*scaleCount+1) = q_layer4(1:2*scaleCount+1).*q_layer4_scaling(1:2*scaleCount+1);
    
    %Calculate the q values for memory layer.
    q_layer_mem = [dot(single(Memory_Img(:)), single(f4(:))) dot(single(Memory_Img_1(:)), single(f4(:)))];
    
%% Select the value of g_layers based on the q values that have been computed

    g_layer1 = g_layer1 - k_xTranslation*( 1-( q_layer1./max(q_layer1) ) );
    
    g_layer2 = g_layer2 - k_yTranslation*( 1-( q_layer2./max(q_layer2) ) );

    g_layer3 = g_layer3 - k_rotation*( 1-( q_layer3./max(q_layer3) ) );
    
    g_layer4 = g_layer4 - k_scaling*( 1-( q_layer4./max(q_layer4) ) );
    
    g_mem = g_mem - k_mem*( 1-( q_layer_mem./max(q_layer_mem) ) );
    
    g_layer1 = g_threshold(g_layer1, gThresh);
    g_layer2 = g_threshold(g_layer2, gThresh);
    g_layer3 = g_threshold(g_layer3, gThresh);
    g_layer4 = g_threshold(g_layer4, gThresh);
    g_mem = g_threshold(g_mem, gThresh);
end

figure(1);
imshow(f1);

figure(2);
imshow(f2);

figure(3);
imshow(f3);

figure(4);
imshow(f4);

figure(5);
imshow(b5);

figure(6);
imshow(b4);

figure(7);
imshow(b3);

figure(8);
imshow(b2);

figure(9);
imshow(Test_Img);

figure(10);
imshow(b1);