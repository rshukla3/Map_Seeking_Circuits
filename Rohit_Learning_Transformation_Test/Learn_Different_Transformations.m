clear all;
close all;
clc;

%% Setting up the parameters.

% 1. This sets the number of times MSC architecture will iterate.
iterationCount = 5;

% 2. Read the already stored images from tif image file.
memory_units = 1;

% 3. Layer count: Has the number of layers currently available.

% Check whether the file has number of learned layers already stored. If no
% then store the default # of layers = 1.
fname = 'layer.txt';
if exist(fname, 'file') == 2
    layersSaved = dlmread(fname, '\t');
else
    layersSaved = 1;
    dlmwrite('layer.txt', layersSaved, '\t');
end
layerCount = 1+layersSaved;

% 4. Set the value of constants k, for multiplication with g.

k_mem = 0.3;
k_xTranslation = 0.5;
k_yTranslation = 0.5;
k_rotation = 0.5;
k_scaling = 0.5;

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

% III. Image Scaling

% We will first start off with a degenrate layer that will later used for
% scaling the input image.

scaleCount = 1;

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

% Save the identity matrix that is to be later used in computation of
% scaling values.

fname = 'scaling_transformation_forward.mat';
scaling_transformation_forward = [1 0 0; 0 1 0; 0 0 1];
if exist(fname, 'file') ~= 2
    save('scaling_transformation_forward.mat', 'scaling_transformation_forward');    
end

fname = 'scaling_transformation_backward.mat';
scaling_transformation_backward = [1 0 0; 0 1 0; 0 0 1];
if exist(fname, 'file') ~= 2
    save('scaling_transformation_backward.mat', 'scaling_transformation_backward');    
end


%% Read the test image and the image that is to be stored in memory.

% Read the test image and the image that is to be stored in memory and
% later do preprocessing on them.

[Preprocessed_Img] = imagePreProcessing('pepper_2.jpg');

%% Assign points of interest to the memory image.
[Img_PointsOfInterest, x , y] = AssignPointsOfInterest(Preprocessed_Img);

%% Perform affine transformations on this memory image.
% Since we do not have any movie of the memory images, so we will be
% generating test images with affine transformations on memory image
% itself. Later we will test our learned transforms on these MATLAB
% generated affine transformations.
%Test_Img = Img_PointsOfInterest;
%Test_Img = translate_img(Img_PointsOfInterest, 0, 100);
Test_Img = single(imrotate(Img_PointsOfInterest, 90, 'nearest', 'crop'));

%% Degenerate layer that just does identity multiplication.

% We will start off with a degerate layer that just performs identity
% matrix multiplication in the beginning. Later this layer will be changed
% to perform scaling operation.

g_scale = single(ones(scaleCount,1));

%% Read the diagonally translated images for learning in MSC.
g_mem(1:memory_units) = single(ones(memory_units,1));

%% Initialize the value of g to all ones for the three layers.

for i = 1:iterationCount
    
% Set the value of backward path 
    b(:,:,layerCount) = layer_memory(g_mem, Img_PointsOfInterest, memory_units);       
    
    f(:,:,1) = (Test_Img);

    % Perform inverse translation on the superimposed image along x-axis.
    b(:,:,layerCount-1) = layer_scaling(b(:,:,layerCount), scaleCount, g_scale, 'backward');

    [f(:,:,layerCount), Tf_scaling] = layer_scaling(f(:,:,layerCount-1), scaleCount, g_scale, 'forward');
    
    q_Top_Layer = dotproduct(f(:,:,1), b(:,:,1));
    
    q_layer_mem(1:memory_units) = single(zeros(1,memory_units));
    q_scaling(1:scaleCount) = single(zeros(1,scaleCount));
    
    % Calculate the value of q_scaling, i.e., the dotproduct achieved at
    % scaling layer.
    q_scaling(1:scaleCount) = dotproduct(Tf_scaling, b(:,:,layerCount));
    
    %Calculate the value of q_layer_mem.    
    q_layer_mem(1:memory_units) = dotproduct(Img_PointsOfInterest, f(:,:,layerCount));       
    
    fprintf('The value of iterationCount is: %d i is: %d\n', iterationCount, i); 
    

    
% Set the value of q to all zeros for the three layers.    
    if(isempty(q_mem))
        q_Top_Layer = dotproduct(Img_PointsOfInterest, Img_PointsOfInterest);
        q_mem(1) = q_Top_Layer;
        q_units = 1;
        dlmwrite('q_mem.txt', q_mem, '\t');
    else
        if(q_Top_Layer<0.4*q_mem(1))
            fprintf('Below Threshold. Learn new transformation!\n');
            [Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward] = learn_new_transformation(Img_PointsOfInterest, Test_Img);
            [isNewLayerAssigned, appendedToLayer] = checkCombinationOfFunctions(Learned_Transformation_Matrix_Forward, layerCount);
            if(isNewLayerAssigned == true)
                layerCount = layerCount+1;
            end
        end
            g_scale = g_scale - k_scaling*( 1-( q_scaling./max(q_scaling) ) );
            g_scale = g_threshold(g_scale, gThresh);                                
            
            g_mem = g_mem - k_mem*( 1-( q_layer_mem./max(q_layer_mem) ) );
            g_mem = g_threshold(g_mem, gThresh);            
    end    
    
end

figure(1);
imshow(b(:,:,1));

figure(2);
imshow(f(:,:,1));