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
    Memory_Img(:, :, 1) = Test_Img;
    memory_units = 2;
    imwrite(Memory_Img(:, :, 1), 'Memory_Images.tif');
    [Test_Img] = imagePreProcessing('sailboat_2.jpg');
    Memory_Img(:, :, 2) = Test_Img;
    imwrite(Memory_Img(:, :, 2), 'Memory_Images.tif');
end

g_mem(1:memory_units) = single(ones(memory_units,1));

%% Initialize the value of g to all ones for the three layers.

g_layer1(1:2*xTranslationCount+1) = single(ones(1,2*xTranslationCount+1));
g_layer2(1:2*yTranslationCount+1) = single(ones(1,2*yTranslationCount+1));
g_layer3(1:2*rotationCount+1) = single(ones(1,2*rotationCount+1));

%% The number of iterations for MSC to run.
for i = 1:iterationCount
    
% Set the value of backward path 
    b(:,:,layerCount) = layer_memory(g_mem, Memory_Img, memory_units);
    
    if(Transformation >= 3)
        % Perform inverse rotation on the backward layer.
        b(:,:,3) = layer_3(b(:,:,4), rotationCount, rotationQuantity, g_layer3, 'backward');
    end
    
    if(Transformation >= 2)
        % Perform inverse translation on the superimposed image along y-axis.
        b(:,:,2) = layer_2(b(:,:,3), yTranslationCount, yTranslateQuantity, g_layer2, 'backward');
    end
    
    if(Transformation >= 1)        
        % Perform inverse translation on the superimposed image along x-axis.
        b(:,:,1) = layer_1(b(:,:,2), xTranslationCount, xTranslateQuantity, g_layer1, 'backward');
    end    
    
    if(Transformation >= 1)
        q_xTranslation(1:2*xTranslationCount+1) = single(zeros(1,2*xTranslationCount+1));
        % Translate the image along x-axis.
        [f(:,:,2), Tf0] = layer_1(Test_Img, xTranslationCount, xTranslateQuantity, g_layer1, 'forward');    
        %Calculate the value of q_xTranslation.
        q_xTranslation(1:2*xTranslationCount+1) = dotproduct(Tf0, b(:,:,2));  
    end
    
    if(Transformation >= 2)
        q_yTranslation(1:2*yTranslationCount+1) = single(zeros(1,2*yTranslationCount+1));
        % Translate the image along y-axis.
        [f(:,:,3), Tf1] = layer_2(f(:,:,2), yTranslationCount, yTranslateQuantity, g_layer2, 'forward');    
        %Calculate the value of q_yTranslation.
        q_yTranslation(1:2*yTranslationCount+1) = dotproduct(Tf1, b(:,:,3));   
    end
    
    if(Transformation >= 3)
        q_rotation(1:2*rotationCount+1) = single(zeros(1,2*rotationCount+1));
        % Rotate the image.
        [f(:,:,4), Tf2] = layer_3(f(:,:,3), rotationCount, rotationQuantity, g_layer3, 'forward');
        %Calculate the value of q_rotation.
        q_rotation(1:2*rotationCount+1) = dotproduct(Tf2, b(:,:,4));   
    end
    
    f(:,:,1) = (Test_Img);
    q_Top_Layer = dotproduct(f(:,:,1), b(:,:,1));
    
    fprintf('The value of iterationCount is: %d i is: %d\n', iterationCount, i); 
    
% Condition to say if MSC has converged to a correct state then break out
% from the loop.
    if(Transformation == 1 && memory_converged == 1 && (xTranslation_converged == 1 || yTranslation_converged == 1 || rotation_converged == 1))
        fprintf('MSC convergence complete in first layer\n');
        break;
    elseif(Transformation == 2 && memory_converged == 1 && ((xTranslation_converged == 1 && yTranslation_converged == 1) || (rotation_converged == 1 && yTranslation_converged == 1) || (xTranslation_converged == 1 && rotation_converged == 1) ))
        fprintf('MSC convergence complete in second layer\n');
        break;
    elseif(Transformation == 3 && memory_converged == 1 && (xTranslation_converged == 1 && yTranslation_converged == 1 && rotation_converged == 1))
        fprintf('MSC convergence complete in third layer\n');
        break;
    end
    
% Set the value of q to all zeros for the three layers.    
    if(isempty(q_mem))
        q_Top_Layer = dotproduct(Memory_Img(:, :, 1), Memory_Img(:, :, 1));
        q_mem(1) = q_Top_Layer;
        q_units = 2;
        
        q_Top_Layer = dotproduct(Memory_Img(:, :, 2), Memory_Img(:, :, 2));
        q_mem(2) = q_Top_Layer;
        dlmwrite('q_mem.txt', q_mem, '\t');
    else
        if(q_Top_Layer<0.4*q_mem(1))
            Transformation = Transformation+1;
            layerCount = layerCount+1;
            b(:,:,layerCount) = b(:,:,layerCount-1);            
        else
            if(Transformation >= 1)
                g_layer1 = g_layer1 - k_xTranslation*( 1-( q_xTranslation./max(q_xTranslation) ) );
                g_layer1 = g_threshold(g_layer1, gThresh);
                if(nnz(g_layer1)==1)
                    xTranslation_converged = 1;
                end
            end    
                
            if(Transformation >= 2)
                g_layer2 = g_layer2 - k_yTranslation*( 1-( q_yTranslation./max(q_yTranslation) ) );
                g_layer2 = g_threshold(g_layer2, gThresh);
                if(nnz(g_layer2)==1)
                    yTranslation_converged = 1;
                end
            end 
            
            if(Transformation >= 3)
                g_layer3 = g_layer3 - k_rotation*( 1-( q_rotation./max(q_rotation) ) );
                g_layer3 = g_threshold(g_layer3, gThresh);
                if(nnz(g_layer3)==1)
                    rotation_converged = 1;
                end
            end
            
            g_mem = g_mem - k_mem*( 1-( q_Top_Layer./max(q_Top_Layer) ) );
            g_mem = g_threshold(g_mem, gThresh);
            
            if(nnz(g_mem)==1)
                memory_converged = 1;
            end
        end
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