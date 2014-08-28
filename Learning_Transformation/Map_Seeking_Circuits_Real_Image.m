clear all;
close all;
clc;

%% Setting up the parameters.

% 1. This sets the number of times MSC architecture will iterate.
iterationCount = 15;

% 2. Read the already stored images from tif image file.
fname = 'Memory_Images.tif';
if exist(fname, 'file') == 2
    info = imfinfo(fname);
    memory_units = numel(info);
    for k = 1:memory_units
        Memory_Img(:,:,k) = imread(fname, k, 'Info', info);
    end
else
    Memory_Img = [];
end

% 3. Layer count: Has the number of layers currently available.

layerCount = 1;

% 4. Set the value of constants k, for multiplication with g.

k_mem = 0.3;
k_xTranslation = 0.5;

% 5. Read the matching values of q already stored in the file.

fname = 'q_mem.txt';
if exist(fname, 'file') == 2
    q_mem = dlmread(fname, '\n');
else
    q_mem = [];
end

% 6. Set the parameters for image translation.

% By how much the image should be translated on x-axis.
xTranslateQuantity = 20;

% Number of times this x-translation that has to be applied.
xTranslationCount = 35;

% 7. Check whether there are any transformations going on in the circuit.
% Initially the value  of transformation is zero, that is no transformation
% is being done.
Transformation = 0;

% If the images are being normalized to single floating point datatype,
% then to display the images, the value of variables should be multiplied
% with 255.

ImageShowNormalize = 255;

%% Read the test image and the image that is to be stored in memory.

% Read the test image and the image that is to be stored in memory and
% later do preprocessing on them.

[Test_Img] = imagePreProcessing();

%% Initialize the value of g to all ones for the three layers.

if(isempty(Memory_Img))
    Memory_Img(:, :, 1) = Test_Img;
    memory_units = 1;
    imwrite(Memory_Img(:, :, 1), 'Memory_Images.tif');
end

g_mem(1:memory_units) = single(ones(memory_units,1));

%% Initialize the value of g to all ones for the three layers.

g_layer1(1:2*xTranslationCount+1) = single(ones(1,2*xTranslationCount+1));


%% The number of iterations for MSC to run.
for i = 1:iterationCount
    
% Set the value of backward path 
    b(:,:,layerCount) = layer_memory(g_mem, Memory_Img, memory_units);
    
    if(Transformation >= 1)
        % Translate the image along x-axis.
        [f(:,:,2), Tf0] = layer_1(Test_Img, xTranslationCount, xTranslateQuantity, g_layer1, 'forward');    
        %Calculate the value of q_layer1.
        q_xTranslation(1:2*xTranslationCount+1) = dotproduct(Tf0, b(:,:,2));        
        
        % Perform inverse translation on the superimposed image along y-axis.
        b(:,:,1) = layer_1(b(:,:,2), xTranslationCount, xTranslateQuantity, g_layer1, 'backward');
    end
    
    f(:,:,1) = Test_Img;
    q_Top_Layer = dotproduct(f(:,:,1), b(:,:,1));
% Set the value of q to all zeros for the three layers.    
    if(isempty(q_mem))
        q_mem(1) = q_Top_Layer;
        q_units = 1;
        dlmwrite('q_mem.txt', q_Top_Layer, '\n');
    else
        if(q_Top_Layer<0.4*q_mem(1))
            Transformation = 1;
            layerCount = 2;
            b(:,:,2) = b(:,:,1);
            q_xTranslation(1:2*xTranslationCount+1) = single(zeros(1,2*xTranslationCount+1));
        else
            if(Transformation >= 1)
                g_layer1 = g_layer1 - k_xTranslation*( 1-( q_xTranslation./max(q_xTranslation) ) );
            end    
    
            g_mem = g_mem - k_mem*( 1-( q_Top_Layer./max(q_Top_Layer) ) );
        end
    end   
    
        
    
     
end

