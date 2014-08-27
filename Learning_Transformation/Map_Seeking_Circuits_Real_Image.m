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

% 5. Read the matching values of q already stored in the file.

fname = 'q_mem.txt';
if exist(fname, 'file') == 2
    q_mem = dlmread(fname, '\n');
else
    q_mem = [];
end

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

g_mem(1:memory_units) = single(ones(1,memory_units));


%% The number of iterations for MSC to run.
for i = 1:iterationCount
    
% Set the value of backward path 
    b(:,:,layerCount) = layer_memory(g_mem, Memory_Img, memory_units);
    
    
% Set the value of q to all zeros for the three layers.

    f(:,:,1) = Test_Img;
    
    q(1) = dotproduct(f(:,:,1), b(:,:,1));
    
    if(isempty(q_mem))
        q_mem(1) = q(1);
        q_units = 1;
        dlmwrite('q_mem.txt', q(1), '\n');
    end
    
    g_mem = g_mem - k_mem*( 1-( q(1)./max(q(1)) ) );
end

