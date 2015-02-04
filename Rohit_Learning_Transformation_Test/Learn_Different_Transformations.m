clear all;
close all;
clc;

%% Setting up the parameters.

% 1. This sets the number of times MSC architecture will iterate.
iterationCount = 25;

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

k_mem = 0.15;
k_layer_1 = 0.3;
k_layer_2 = 0.3;
k_layer_3 = 0.3;
k_layer_4 = 0.3;
k_layer_5 = 0.3;
k_layer_6 = 0.3;
k_scaling = 0.3;

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

%% Read the images that have to be stored in the memory. 

% Two separate memory locations will be allocated for storing images. One
% memory location will store all the edge detected images, that will be
% later used in MSC. 
% Second memory location will store segmented images that will be later
% used for learning transformations.

[Preprocessed_Img, Memory_PreProcessed_Img] = imagePreProcessing('sailboat_2.jpg');
[m,n] = size(Preprocessed_Img);
mem_img(1:m, 1:n, 1) = Preprocessed_Img;
learn_mem_img(1:m,1:n,1) = Memory_PreProcessed_Img;
% [Preprocessed_Img, Memory_PreProcessed_Img] = imagePreProcessing('sailboat_2.jpg');
% [m,n] = size(Preprocessed_Img);
% mem_img(1:m, 1:n, 2) = Preprocessed_Img;
% learn_mem_img(1:m,1:n,2) = Memory_PreProcessed_Img;

fname = 'mem_img.mat';
if exist(fname, 'file') ~= 2
    save('mem_img.mat', 'mem_img');    
end

fname = 'learn_mem_img.mat';
if exist(fname, 'file') ~= 2
    save('learn_mem_img.mat', 'learn_mem_img');    
end


%% Read the test image and the image that is to be stored in memory.

% Read the test image.

[Preprocessed_Img, Memory_PreProcessed_Img] = imagePreProcessing_gray('monopoly_robot.jpg');
Img_PointsOfInterest = Preprocessed_Img;

Test_Img = Img_PointsOfInterest;
Learning_Test_Img = Memory_PreProcessed_Img;
%% Assign points of interest to the memory image.
%[Img_PointsOfInterest, x , y] = AssignPointsOfInterest(Preprocessed_Img);

%% Perform affine transformations on this memory image.
% Since we do not have any movie of the memory images, so we will be
% generating test images with affine transformations on memory image
% itself. Later we will test our learned transforms on these MATLAB
% generated affine transformations.
% Test_Img = Img_PointsOfInterest;

% Scaling = 0.8;
% Test_Img_1 = scaleImg(Img_PointsOfInterest, Scaling, Scaling);
% Learning_Test_Img_1 = scaleImg(Memory_PreProcessed_Img, Scaling, Scaling);
% 
% Rotation = -30;
% Test_Img_2 = single(imrotate(Test_Img_1, Rotation, 'nearest', 'crop'));
% Learning_Test_Img_2 = single(imrotate(Learning_Test_Img_1, Rotation, 'nearest', 'crop'));
%  
% x_Translation = -100;
% y_Translation = 100;
% Test_Img = translate_img(Test_Img_2, x_Translation, y_Translation);
% Learning_Test_Img = translate_img(Learning_Test_Img_2, x_Translation, y_Translation);


figure(1);
imshow(Test_Img);
pause(1);


%% Is this the learning phase? 
% Is this experiment implementing the learning phase? If not then next
% layer or below threshold section should not be executed.

% This is particularly meant for testing when scaling is implemented. I
% noticed that even though the answers are correct, the MSC went into
% learning phase. This might be due to discretization. When we scale up, a
% lot of pixels get replicated or repeated. That is why q_mem value is
% always higher than q_top_layer. To circumvent this problem I've added
% this condition.

learning = true; 

fname = 'g_mem.mat';
if exist(fname, 'file') ~= 2
    save('g_mem.mat', 'memory_units');    
else
    load('g_mem.mat', 'memory_units');    
end
g_mem = single(ones(1,memory_units));
%% Degenerate layer that just does identity multiplication.

% We will start off with a degerate layer that just performs identity
% matrix multiplication in the beginning. Later this layer will be changed
% to perform scaling operation.

fname = 'g_scale.mat';
if exist(fname, 'file') ~= 2
    save('g_scale.mat', 'scaleCount');    
else
    load('g_scale.mat', 'scaleCount');    
end
g_scale = single(ones(1,scaleCount));
%% Read the g values of other values in layersSaved is more than 1.

% If the value of layersSaved is more than 1 (that is, the value of
% layerCount is more than 2), this implies that we should already have some
% information about g for other layers. To resolve this issue we have saved
% the value of g in text files. For a much simpler implementation we can
% simply check the value of layerCount and if it is more  than 2, just read
% the transformation matrices for different layers. To know how many
% transformations we have stored, simply look at the third dimension of
% these transformation matrices.

if(layerCount >= 3)
    fname = 'g_layer_1.mat';
    if exist(fname, 'file') == 2
        load(fname, 'layer_1_Count');    
    else
        fprintf('Specified file not found for g_layer_1\n');
        return;
    end          
    g_layer_1 = single(ones(1,layer_1_Count));
end
                
if(layerCount >= 4)
    fname = 'g_layer_2.mat';
    if exist(fname, 'file') == 2
        load(fname, 'layer_2_Count');    
    else
        fprintf('Specified file not found for g_layer_2\n');
        return;
    end          
    g_layer_2 = single(ones(1,layer_2_Count));
end
                
if(layerCount >= 5)
    fname = 'g_layer_3.mat';
    if exist(fname, 'file') == 2
        load(fname, 'layer_3_Count');    
    else
        fprintf('Specified file not found for g_layer_3\n');
        return;
    end          
    g_layer_3 = single(ones(1,layer_3_Count));
end

if(layerCount >= 6)
    fname = 'g_layer_4.mat';
    if exist(fname, 'file') == 2
        load(fname, 'layer_4_Count');    
    else
        fprintf('Specified file not found for g_layer_4\n');
        return;
    end          
    g_layer_4 = single(ones(1,layer_4_Count));
end

if(layerCount >= 7)
    fname = 'g_layer_5.mat';
    if exist(fname, 'file') == 2
        load(fname, 'layer_5_Count');    
    else
        fprintf('Specified file not found for g_layer_5\n');
        return;
    end          
    g_layer_5 = single(ones(1,layer_5_Count));
end

if(layerCount >= 8)
    fname = 'g_layer_6.mat';
    if exist(fname, 'file') == 2
        load(fname, 'layer_6_Count');    
    else
        fprintf('Specified file not found for g_layer_6\n');
        return;
    end          
    g_layer_6 = single(ones(1,layer_6_Count));
end
%% Read the diagonally translated images for learning in MSC.
g_mem(1:memory_units) = single(ones(memory_units,1));

%% Initialize the value of q_mem(1).

q_Top_Layer = dotproduct(Test_Img, Test_Img);
q_mem(1) = q_Top_Layer;

%% Count the number of times MSC tries to learn image.

%Count the number of times MSC tries to learn image when a new object is
%shown. This should not be more than once.

learnCount = 1;

for i = 1:iterationCount
    
% Set the value of backward path 
    [b(:,:,layerCount), mem_img] = layer_memory(g_mem, Img_PointsOfInterest, memory_units);       
    
    f(:,:,1) = (Test_Img);

    % Perform inverse translation on the superimposed image along x-axis.
    b(:,:,layerCount-1) = layer_scaling(b(:,:,layerCount), g_scale, 'backward');
    
    if(layerCount >= 3)
        b(:,:,layerCount-2) = layer_1(b(:,:,layerCount-1), g_layer_1, 'backward', 2);
    end
    
    if(layerCount >= 4)
        b(:,:,layerCount-3) = layer_1(b(:,:,layerCount-2), g_layer_2, 'backward', 3);
    end
    
    if(layerCount >= 5)
        b(:,:,layerCount-4) = layer_1(b(:,:,layerCount-3), g_layer_3, 'backward', 4);
    end
    
    if(layerCount >= 6)
        b(:,:,layerCount-5) = layer_1(b(:,:,layerCount-4), g_layer_4, 'backward', 5);
    end
    
    if(layerCount >= 7)        
        b(:,:,layerCount-6) = layer_1(b(:,:,layerCount-5), g_layer_5, 'backward', 6);
    end
    
    if(layerCount >= 8)        
        b(:,:,layerCount-7) = layer_1(b(:,:,layerCount-6), g_layer_6, 'backward', 7);
    end

 % Set the values of forward path 
    if(layerCount >= 8)
        [f(:,:,layerCount-6), Tf_layer_6] = layer_1(f(:,:,layerCount-7), g_layer_6, 'forward', 7);
    end
 
    if(layerCount >= 7)
        [f(:,:,layerCount-5), Tf_layer_5] = layer_1(f(:,:,layerCount-6), g_layer_5, 'forward', 6);
    end
 
    if(layerCount >= 6)
        [f(:,:,layerCount-4), Tf_layer_4] = layer_1(f(:,:,layerCount-5), g_layer_4, 'forward', 5);
    end
    
    if(layerCount >= 5)
        [f(:,:,layerCount-3), Tf_layer_3] = layer_1(f(:,:,layerCount-4), g_layer_3, 'forward', 4);
    end
    
    if(layerCount >= 4)
        [f(:,:,layerCount-2), Tf_layer_2] = layer_1(f(:,:,layerCount-3), g_layer_2, 'forward', 3);
    end
    
    if(layerCount >= 3)
        [f(:,:,layerCount-1), Tf_layer_1] = layer_1(f(:,:,layerCount-2), g_layer_1, 'forward', 2);
    end

    [f(:,:,layerCount), Tf_scaling] = layer_scaling(f(:,:,layerCount-1), g_scale, 'forward');    
    
    q_Top_Layer = dotproduct(f(:,:,1), b(:,:,1));
    
    q_layer_mem(1:memory_units) = single(zeros(1,memory_units));
    q_scaling(1:scaleCount) = single(zeros(1,scaleCount));
    
    if(layerCount >= 3)
        % Calculate the value of q_layer_1, i.e., the dotproduct achieved at
        % layer 1 of MSC.
        q_layer_1(1:layer_1_Count) = single(zeros(1,layer_1_Count));
        q_layer_1(1:layer_1_Count) = dotproduct(Tf_layer_1, b(:,:,layerCount-1));
    end
    
    if(layerCount >= 4)
        % Calculate the value of q_layer_2, i.e., the dotproduct achieved at
        % layer 2 of MSC.
        q_layer_2(1:layer_2_Count) = single(zeros(1,layer_2_Count));
        q_layer_2(1:layer_2_Count) = dotproduct(Tf_layer_2, b(:,:,layerCount-2));
    end
    
    if(layerCount >= 5)
        % Calculate the value of q_layer_3, i.e., the dotproduct achieved at
        % layer 3 of MSC.
        q_layer_3(1:layer_3_Count) = single(zeros(1,layer_3_Count));
        q_layer_3(1:layer_3_Count) = dotproduct(Tf_layer_3, b(:,:,layerCount-3));
    end
    
    if(layerCount >= 6)
        % Calculate the value of q_layer_4, i.e., the dotproduct achieved at
        % layer 4 of MSC.
        q_layer_4(1:layer_4_Count) = single(zeros(1,layer_4_Count));
        q_layer_4(1:layer_4_Count) = dotproduct(Tf_layer_4, b(:,:,layerCount-4));
    end
    
    if(layerCount >= 7)
        % Calculate the value of q_layer_5, i.e., the dotproduct achieved at
        % layer 5 of MSC.
        q_layer_5(1:layer_5_Count) = single(zeros(1,layer_5_Count));
        q_layer_5(1:layer_5_Count) = dotproduct(Tf_layer_5, b(:,:,layerCount-5));
    end
    
    if(layerCount >= 8)
        % Calculate the value of q_layer_5, i.e., the dotproduct achieved at
        % layer 5 of MSC.
        q_layer_6(1:layer_6_Count) = single(zeros(1,layer_6_Count));
        q_layer_6(1:layer_6_Count) = dotproduct(Tf_layer_6, b(:,:,layerCount-6));
    end
    
    % Calculate the value of q_scaling, i.e., the dotproduct achieved at
    % scaling layer.
    q_scaling(1:scaleCount) = dotproduct(Tf_scaling, b(:,:,layerCount));
    
    %Calculate the value of q_layer_mem.    
    q_layer_mem(1:memory_units) = dotproduct(mem_img, f(:,:,layerCount));       
    
    fprintf('The value of iterationCount is: %d i is: %d\n', iterationCount, i); 
    
    F_1 = memory_units*sum(sum(f(:,:,1)));
    B_1 = sum(sum(b(:,:,layerCount)));
    Q = q_mem(1)*(B_1/F_1)*0.3;
% Set the value of q to all zeros for the three layers.    
    if(isempty(q_mem))
        q_Top_Layer = dotproduct(Img_PointsOfInterest, Img_PointsOfInterest);
        q_mem(1) = q_Top_Layer;
        q_units = 1;
        dlmwrite('q_mem.txt', q_mem, '\t');
    else
        if(q_Top_Layer<0.3*q_mem(1)*(B_1/F_1) && learning == true && learnCount == 1)
        %if(q_Top_Layer==0)
            fprintf('Below Threshold. Learn new transformation!\n');           
            if(learnCount == 2)
%                 break;
            end
            
            learnCount = learnCount + 1;
            isNewLayerAssigned = false;
            appendedToLayer = 0;
%             [Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward] = learn_new_transformation(Img_PointsOfInterest, Test_Img);
%              [Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward] = learn_new_transformation_feat_ext(Memory_PreProcessed_Img, Learning_Test_Img);
            [Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward, objectFound] = learn_new_transformation_feat_ext_multi_img(Learning_Test_Img, Test_Img);
            
            % This function needs to be changed in case we have multiple
            % transformations going on. Instead of checking for just one
            % column or one transformation at a time, check for multiple of
            % them. 
            if(objectFound == true)
                [isNewLayerAssigned, appendedToLayer] = checkCombinationOfFunctions(Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward, layerCount);
                fprintf('appendedToLayer: %d\n', appendedToLayer);
                return;
            else
                memory_units = memory_units + 1;
                g_mem = single(ones(1,memory_units));
                fname = 'g_mem.mat';
                if exist(fname, 'file') == 2
                    save(fname, 'memory_units');    
                else
                    fprintf('File for g_mem does not exist\n');
                    return;
                end 
                
                % Since a new object has been added, re-implement the
                % entire MSC functions with all of the other g values
                % re-initialized to one.
                g_mem = single(ones(1,memory_units));
                g_scale = single(ones(1,scaleCount));
                if(layerCount >= 3)
                    g_layer_1 = single(ones(1,layer_1_Count));
                end
                if(layerCount >= 4)
                    g_layer_2 = single(ones(1,layer_2_Count));
                end
                if(layerCount >= 5)
                    g_layer_3 = single(ones(1,layer_3_Count));
                end
                if(layerCount >= 6)
                    g_layer_4 = single(ones(1,layer_4_Count));
                end
                if(layerCount >= 7)
                    g_layer_5 = single(ones(1,layer_5_Count));
                end
                if(layerCount >= 8)
                    g_layer_6 = single(ones(1,layer_6_Count));
                end
            end
            
            
            if(isNewLayerAssigned == true && objectFound == true)
                layerCount = layerCount+1;
                fprintf('A new layer has been assigned\n');
                % Update the layer count for MSC.
                updateLayerCountFile(layerCount);
                % Save the new affine transformation for the new
                % independent functions.
                assignNewIndependentLayer(Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward, layerCount); 
                
                if(layerCount == 3)
                    layer_1_Count = 2;
                    g_layer_1 = single(ones(1,layer_1_Count));
                    fname = 'g_layer_1.mat';
                    if exist(fname, 'file') ~= 2
                        save(fname, 'layer_1_Count');    
                    else
                        fprintf('Delete file for g_layer_1\n');
                        return;
                    end          
                end
                
                if(layerCount == 4)
                    layer_2_Count = 2;
                    g_layer_2 = single(ones(1,layer_2_Count));
                    fname = 'g_layer_2.mat';
                    if exist(fname, 'file') ~= 2
                        save(fname, 'layer_2_Count');    
                    else
                        fprintf('Delete file for g_layer_2\n');
                        return;
                    end          
                end
                
                if(layerCount == 5)
                    layer_3_Count = 2;
                    g_layer_3 = single(ones(1,layer_3_Count));
                    fname = 'g_layer_3.mat';
                    if exist(fname, 'file') ~= 2
                        save(fname, 'layer_3_Count');    
                    else
                        fprintf('Delete file for g_layer_3\n');
                        return;
                    end          
                end
                
                if(layerCount == 6)
                    layer_4_Count = 2;
                    g_layer_4 = single(ones(1,layer_4_Count));
                    fname = 'g_layer_4.mat';
                    if exist(fname, 'file') ~= 2
                        save(fname, 'layer_4_Count');    
                    else
                        fprintf('Delete file for g_layer_4\n');
                        return;
                    end          
                end
                
                if(layerCount == 7)
                    layer_5_Count = 2;
                    g_layer_5 = single(ones(1,layer_5_Count));
                    fname = 'g_layer_5.mat';
                    if exist(fname, 'file') ~= 2
                        save(fname, 'layer_5_Count');    
                    else
                        fprintf('Delete file for g_layer_5\n');
                        return;
                    end          
                end
                
                if(layerCount == 8)
                    layer_6_Count = 2;
                    g_layer_6 = single(ones(1,layer_6_Count));
                    fname = 'g_layer_6.mat';
                    if exist(fname, 'file') ~= 2
                        save(fname, 'layer_6_Count');    
                    else
                        fprintf('Delete file for g_layer_6\n');
                        return;
                    end          
                end
                
                % Since a new object has been added, re-implement the
                % entire MSC functions with all of the other g values
                % re-initialized to one.
                g_mem = single(ones(1,memory_units));
                g_scale = single(ones(1,scaleCount));
                if(layerCount >= 3)
                    g_layer_1 = single(ones(1,layer_1_Count));
                end
                if(layerCount >= 4)
                    g_layer_2 = single(ones(1,layer_2_Count));
                end
                if(layerCount >= 5)
                    g_layer_3 = single(ones(1,layer_3_Count));
                end
                if(layerCount >= 6)
                    g_layer_4 = single(ones(1,layer_4_Count));
                end
                if(layerCount >= 7)
                    g_layer_5 = single(ones(1,layer_5_Count));
                end
                if(layerCount >= 8)
                    g_layer_6 = single(ones(1,layer_6_Count));
                end
                
            elseif(appendedToLayer ~= 0 && objectFound == true)
                fprintf('Value of appendedToLayer in update case is: %d\n', appendedToLayer);
                gCount = updateIndependentLayer(Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward, appendedToLayer); 
                % Need to update gCount for all the layers. This part was
                % not taken care of in the original code.
                if((appendedToLayer == 1))
                    scaleCount = scaleCount + 1;
                    g_scale = single(ones(1,scaleCount));
                    fname = 'g_scale.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'scaleCount');    
                    else
                        fprintf('File for g_scale does not exist\n');
                        return;
                    end 
                end
                
                if((appendedToLayer == 2))
                    layer_1_Count = layer_1_Count + 1;
                    g_layer_1 = single(ones(1,layer_1_Count));
                    fname = 'g_layer_1.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'layer_1_Count');    
                    else
                        fprintf('File for g_layer_1 does not exist\n');
                        return;
                    end      
                end
                
                if((appendedToLayer == 3))
                    layer_2_Count = layer_2_Count + 1;
                    g_layer_2 = single(ones(1,layer_2_Count));
                    fname = 'g_layer_2.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'layer_2_Count');    
                    else
                        fprintf('File for g_layer_2 does not exist\n');
                        return;
                    end          
                end
                
                if((appendedToLayer == 4))
                    layer_3_Count = layer_3_Count + 1;
                    g_layer_3 = single(ones(1,layer_3_Count));
                    fname = 'g_layer_3.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'layer_3_Count');    
                    else
                        fprintf('File for g_layer_3 does not exist\n');
                        return;
                    end         
                end
                
                if((appendedToLayer == 5))
                    layer_4_Count = layer_4_Count + 1;
                    g_layer_4 = single(ones(1,layer_4_Count));
                    fname = 'g_layer_4.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'layer_4_Count');    
                    else
                        fprintf('File for g_layer_4 does not exist\n');
                        return;
                    end 
                end
                
                if((appendedToLayer == 6))
                    layer_5_Count = layer_5_Count + 1;
                    g_layer_5 = single(ones(1,layer_5_Count));
                    fname = 'g_layer_5.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'layer_5_Count');    
                    else
                        fprintf('File for g_layer_5 does not exist\n');
                        return;
                    end   
                end
                
                if((appendedToLayer == 7))
                    layer_6_Count = layer_6_Count + 1;
                    g_layer_6 = single(ones(1,layer_6_Count));
                    fname = 'g_layer_6.mat';
                    if exist(fname, 'file') == 2
                        save(fname, 'layer_6_Count');    
                    else
                        fprintf('File for g_layer_6 does not exist\n');
                        return;
                    end                     
                end
                % Since a new transformation function has been learnt,
                % re-implement the entire MSC functions with all of the
                % other g values re-initialized to one.
                g_mem = single(ones(1,memory_units));
                g_scale = single(ones(1,scaleCount));
                if(layerCount >= 3)
                    g_layer_1 = single(ones(1,layer_1_Count));
                end
                if(layerCount >= 4)
                    g_layer_2 = single(ones(1,layer_2_Count));
                end
                if(layerCount >= 5)
                    g_layer_3 = single(ones(1,layer_3_Count));
                end
                if(layerCount >= 6)
                    g_layer_4 = single(ones(1,layer_4_Count));
                end
                if(layerCount >= 7)
                    g_layer_5 = single(ones(1,layer_5_Count));
                end
                if(layerCount >= 8)
                    g_layer_6 = single(ones(1,layer_6_Count));
                end
            end
        else
            g_scale = g_scale - k_scaling*( 1-( q_scaling./max(q_scaling) ) );
            g_scale = g_threshold(g_scale, gThresh);                                
            
            g_mem = g_mem - k_mem*( 1-( q_layer_mem./max(q_layer_mem) ) );
            g_mem = g_threshold(g_mem, gThresh);   
            
            if(layerCount >= 3)
                div = ( q_layer_1./max(q_layer_1));
                g_layer_1 = g_layer_1 - k_layer_1*( 1-div ) ;
                g_layer_1 = g_threshold(g_layer_1, gThresh);                                
            end
            
            if(layerCount >= 4)
                g_layer_2 = g_layer_2 - k_layer_2*( 1-( q_layer_2./max(q_layer_2) ) );
                g_layer_2 = g_threshold(g_layer_2, gThresh);                                
            end
            
            if(layerCount >= 5)
                g_layer_3 = g_layer_3 - k_layer_3*( 1-( q_layer_3./max(q_layer_3) ) );
                g_layer_3 = g_threshold(g_layer_3, gThresh);                                
            end
            
            if(layerCount >= 6)
                g_layer_4 = g_layer_4 - k_layer_4*( 1-( q_layer_4./max(q_layer_4) ) );
                g_layer_4 = g_threshold(g_layer_4, gThresh);                                
            end
            
            if(layerCount >= 7)
                g_layer_5 = g_layer_5 - k_layer_5*( 1-( q_layer_5./max(q_layer_5) ) );
                g_layer_5 = g_threshold(g_layer_5, gThresh);                                
            end
            
            if(layerCount >= 8)
                g_layer_6 = g_layer_6 - k_layer_6*( 1-( q_layer_6./max(q_layer_6) ) );
                g_layer_6 = g_threshold(g_layer_6, gThresh);                                
            end 
         
        end
        
    end    
    
end

% [Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward] = learn_new_transformation(Img_PointsOfInterest, Test_Img);
% 
% D = det(Learned_Transformation_Matrix_Forward);
% fprintf('The value of determinant is: %d\n', D);
figure(1);
imshow(b(:,:,1));

figure(2);
imshow(b(:,:,2));

if(layerCount >= 3)
    figure(3);
    imshow(b(:,:,3));
end

if(layerCount >= 4)
    figure(4);
    imshow(b(:,:,4));
end

if(layerCount >= 5)
    figure(5);
    imshow(b(:,:,5));
end

if(layerCount >= 6)
    figure(6);
    imshow(b(:,:,6));
end



figure(7);
imshow(f(:,:,1));

figure(8);
imshow(f(:,:,2));

if(layerCount >= 3)
    figure(9);
    imshow(f(:,:,3));
end

if(layerCount >= 4)
    figure(10);
    imshow(f(:,:,4));
end

if(layerCount >= 5)
    figure(11);
    imshow(f(:,:,5));
end

if(layerCount >= 6)
    figure(12);
    imshow(f(:,:,6));
end
