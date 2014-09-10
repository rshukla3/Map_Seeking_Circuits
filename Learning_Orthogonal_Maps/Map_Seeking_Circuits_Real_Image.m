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

%% Read the translated images for learning in MSC.

fname = 'Movie_Matrix_Horizontal.mat';
if exist(fname, 'file') == 2
    load('Movie_Matrix_Horizontal.mat', 'Movie_Img_Horizontal');    
else
    fprintf('The selected .mat file does not exist\n');    
    exit(0);
end

fname = 'Movie_Matrix_Vertical.mat';
if exist(fname, 'file') == 2
    load('Movie_Matrix_Vertical.mat', 'Movie_Img_Vertical');    
else
    fprintf('The selected .mat file does not exist\n');    
    exit(0);
end

% Get the number of movie images.

[m,n,Movie_Image_Count_Horizontal] = size(Movie_Img_Horizontal);
[m,n,Movie_Image_Count_Vertical] = size(Movie_Img_Vertical);

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
Memory_Img(:, :, 1) = single(Test_Img);


%% Number of images to be learned by MSC.

delete('Transformation_Matrix.mat');

for i = 1:Movie_Image_Count_Horizontal
       [Transformation_Matrix, memory_unit, learned_flag] = layer_1_learned(single(Movie_Img_Horizontal(:,:,i)), Memory_Img(:,:,1)); 
       b(:,:,1) = Transformation_Matrix(:,:,memory_unit)+Memory_Img(:,:,1);       
       f(:,:,1) = Test_Img;       
end

for i = 1:Movie_Image_Count_Vertical
       [Transformation_Matrix, memory_unit, learned_flag] = layer_1_learned(single(Movie_Img_Vertical(:,:,i)), Memory_Img(:,:,1)); 
       b(:,:,1) = Transformation_Matrix(:,:,memory_unit)+Memory_Img(:,:,1);       
       f(:,:,1) = Test_Img;       
end


%% Read the diagonally translated images for learning in MSC.
fname = 'Diagonal_Movie_Matrix.mat';
if exist(fname, 'file') == 2
    load('Diagonal_Movie_Matrix.mat', 'Diagonal_Movie_Img');    
else
    fprintf('The selected .mat file does not exist\n');    
    exit(0);
end

Test_Img = single(Diagonal_Movie_Img(:,:,1));

g_mem(1:memory_units) = single(ones(memory_units,1));

%% Initialize the value of g to all ones for the three layers.

%Subtracting one from the following equation because there is zero
%translation case present in both xTranslation and yTranslation.
g_layer(1:(Movie_Image_Count_Horizontal+Movie_Image_Count_Vertical-1)) = single(ones(1,(Movie_Image_Count_Horizontal+Movie_Image_Count_Vertical-1)));

for i = 1:iterationCount
    
% Set the value of backward path 
    b(:,:,layerCount) = layer_memory(g_mem, Memory_Img, memory_units);
    
       
%     if(Transformation >= 1)        
%         % Perform inverse translation on the superimposed image along x-axis.
%         b(:,:,1) = layer_1_newTransformation(b(:,:,2), Movie_Img_Horizontal, Movie_Img_Vertical, g_layer, 'backward');
%     end    
%     
%     if(Transformation >= 1)
%         q_translation(1:(Movie_Image_Count_Horizontal*Movie_Image_Count_Vertical)) = single(zeros(1,(Movie_Image_Count_Horizontal*Movie_Image_Count_Vertical)));
%         % Translate the image along x-axis.
%         [f(:,:,2), Tf0] = layer_1_newTransformation(Test_Img, Movie_Img_Horizontal, Movie_Img_Vertical, g_layer, 'forward');    
%         %Calculate the value of q_xTranslation.
%         q_translation(1:(Movie_Image_Count_Horizontal*Movie_Image_Count_Vertical)) = dotproduct(Tf0, b(:,:,2));  
%     end   
    
    f(:,:,1) = (Test_Img);
    q_Top_Layer = dotproduct(f(:,:,1), b(:,:,1));
    
    q_layer_mem(1:memory_units) = single(zeros(1,memory_units));
    %Calculate the value of q_layer_mem.    
    q_layer_mem(1:memory_units) = dotproduct(Memory_Img, f(:,:,layerCount));       
    
    %q_layer_mem = dot(single(Memory_Img(:)), single(f3(:)));
    
    fprintf('The value of iterationCount is: %d i is: %d\n', iterationCount, i); 
    

    
% Set the value of q to all zeros for the three layers.    
    if(isempty(q_mem))
        q_Top_Layer = dotproduct(Memory_Img(:, :, 1), Memory_Img(:, :, 1));
        q_mem(1) = q_Top_Layer;
        q_units = 1;
    else
        if(q_Top_Layer<0.4*q_mem(1))
            fprintf('Below Threshold\n');
%             if(layerCount < 4)
%                 Transformation = Transformation+1;            
%                 layerCount = layerCount+1;
%                 b(:,:,layerCount) = b(:,:,layerCount-1);            
%             end
        else
%             if(Transformation >= 1)
%                 g_layer = g_layer - k_xTranslation*( 1-( q_xTranslation./max(q_xTranslation) ) );
%                 g_layer = g_threshold(g_layer, gThresh);                
%             end    
                
            
            g_mem = g_mem - k_mem*( 1-( q_layer_mem./max(q_layer_mem) ) );
            g_mem = g_threshold(g_mem, gThresh);            
         end
    end    
    
end

%b(:,:,1) = Transformation_Matrix(:,:,1)+Memory_Img(:,:,1);
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