clear all;
close all;
clc;

%% Setting up the parameters.

% 1. This sets the number of times MSC architecture will iterate.
iterationCount = 25;

% 2. Read the already stored images from tif image file.
fname = 'Memory_Images.tif';
if exist(fname, 'file') == 2
    info = imfinfo(fname);
    memory_units = numel(info);
    for k = 1:memory_units
        Memory_Img(:,:,k) = single(logical(imread(fname, k, 'Info', info)));
    end
else
    Memory_Img = [];
end

% 3. Layer count: Has the number of layers currently available.

layerCount = 1;

% 4. Set the value of constants k, for multiplication with g.

k_mem = 0.3;
k_xTranslation = 0.5;
k_yTranslation = 0.5;
k_rotation = 0.5;

% 5. Read the matching values of q already stored in the file.

fname = 'q_mem.txt';
if exist(fname, 'file') == 2
    q_mem = dlmread(fname, '\t');
else
    q_mem = [];
end

% 6. Set the parameters for affine transformations.

% I: Image translation

% By how much the image should be translated on x-axis.
xTranslateQuantity = 20;

% By how much the image should be translated on y-axis.
yTranslateQuantity = 20;

% Number of times this x-translation that has to be applied.
xTranslationCount = 30;

% Number of times this y-translation that has to be applied.
yTranslationCount = 30;

% II. Image rotation.

% This term defines the number of times input image should be rotated
rotationCount = 6;

% The precision by which image should be rotated.
rotationQuantity = 15;

% 7. Check whether there are any transformations going on in the circuit.
% Initially the value  of transformation is zero, that is no transformation
% is being done.
Transformation = 0;

% 8. Select the value of gThresh or threshold value of g.
gThresh = 0.3;

% Check whether the mapping layers have converged or not.
xTranslation_converged = 0;
yTranslation_converged = 0;
rotation_converged = 0;
memory_converged = 0;

% If the images are being normalized to single floating point datatype,
% then to display the images, the value of variables should be multiplied
% with 255.

ImageShowNormalize = 255;

%% Read the test image and the image that is to be stored in memory.

% Read the test image and the image that is to be stored in memory and
% later do preprocessing on them.

[Test_Img] = imagePreProcessing('pepper_2.jpg');

%% Initialize the value of g to all ones for the three layers.

if(isempty(Memory_Img))
    Memory_Img(:, :, 1) = single(Test_Img);
    memory_units = 1;
    imwrite(Memory_Img(:, :, 1), 'Memory_Images.tif');    
end
%Memory_Img(:, :, 1) = single(Test_Img);
g_mem(1:memory_units) = single(ones(memory_units,1));

%% Initialize the value of g to all ones for the three layers.

g_layer1(1:2*xTranslationCount+1) = single(ones(1,2*xTranslationCount+1));
g_layer2(1:2*yTranslationCount+1) = single(ones(1,2*yTranslationCount+1));
g_layer3(1:2*rotationCount+1) = single(ones(1,2*rotationCount+1));

%% The number of iterations for MSC to run.
for i = 1:iterationCount
       [Transformation_Matrix, memory_unit, learned_flag] = layer_1_learned(Test_Img, Memory_Img(:,:,1)); 
       b(:,:,1) = Transformation_Matrix(:,:,memory_unit)+Memory_Img(:,:,1);
       
       f(:,:,1) = Test_Img;
       
       if(learned_flag == 1)
           break;
       end
end

figure(3);
imshow(b(:,:,1));

if(Transformation >= 1)
    figure(4);
    imshow(b(:,:,2));    
end

if(Transformation >= 2)
    figure(5);
    imshow(b(:,:,3));
end

if(Transformation >= 3)
    figure(6);
    imshow(b(:,:,4));
end

figure(7);
imshow(f(:,:,1));

if(Transformation >= 1)
    figure(8);
    imshow(f(:,:,2));
end

if(Transformation >= 2)
    figure(9);
    imshow(f(:,:,3));    
end

if(Transformation >= 3)
    figure(10);
    imshow(f(:,:,4));    
end