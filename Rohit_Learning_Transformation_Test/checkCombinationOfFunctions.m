function [ isNewLayerAssigned, appendedToLayer ] = checkCombinationOfFunctions( affine_transformation_matrix_forward, affine_transformation_matrix_backward, layerCount )
%checkCombinationOfFunctions: Checks whether the new learned transformation
%is a combination of already existing layers or is it a new independent
%function.
%   To check whether the new affine transformation matrix is a combination
%   of previously learned independent functions or is it a new learned
%   independent function, we look at the rank of the matrix. Rank will tell
%   us whether this new function is a combination previous independent
%   functions or is it a completely new independent function. 

% One thing to note is that rank of the matrix is not able to distinguish
% between clockwise and counterclockwise rotations. Thus, to circumvent
% this problem, this function will be performing checks using bot backward
% and forward transformations. 

    isNewLayerAssigned = false;
    appendedToLayer = 1;
    layersSaved = layerCount - 1;
    
    % index variable will parse through or check through every layer and
    % confirm whether this new affine transformation is a combination of
    % previously learned independent functions. 
    index = 1;
    Transformation_Matrices_Indices = 1;
    while(index <= layersSaved)
        
        % First check whether it is a part of scaling layer.
        if(index == 1)
            
            % Perform rank check for forward path matrices.
            fname = 'scaling_transformation_forward.mat';
            if exist(fname, 'file') == 2
                load('scaling_transformation_forward.mat', 'scaling_transformation_forward');    
            else
                fprintf('The selected scaling_transformation_forward.mat file does not exist\n');    
            end                      
            
            % Perform rank check for backward path matrices.
            fname = 'scaling_transformation_backward.mat';
            if exist(fname, 'file') == 2
                load('scaling_transformation_backward.mat', 'scaling_transformation_backward');    
            else
                fprintf('The selected scaling_transformation_backward.mat file does not exist\n');    
            end
            
            Transformation_Matrices_Stored(:,:,Transformation_Matrices_Indices) = scaling_transformation_forward(:,:,1);
            Transformation_Matrices_Indices = Transformation_Matrices_Indices + 1;
            Transformation_Matrices_Stored(:,:,Transformation_Matrices_Indices) = scaling_transformation_backward(:,:,1);
            Transformation_Matrices_Indices = Transformation_Matrices_Indices + 1;
            independent = rankOfMatrix(affine_transformation_matrix_forward, Transformation_Matrices_Stored, index+1);
            
            if(independent == false) 
                isNewLayerAssigned = false;
                findResult_forward = findWhetherExisting(affine_transformation_matrix_forward, scaling_transformation_forward);
                findResult_backward = findWhetherExisting(affine_transformation_matrix_forward, scaling_transformation_backward);
%                 fprintf('The value of independent_forward is %d, independent_backward is %d and findResult_forward is %d, findResult_backward is %d\n', independent_forward, independent_backward, findResult_forward, findResult_backward);
                
                if(findResult_forward == false && findResult_backward == false)
                    appendedToLayer = 1;
                else 
                    % scaling_transformation_forward
                    appendedToLayer = 0;
                end
                break;                
            else
                isNewLayerAssigned = true;
                appendedToLayer = 0;
            end            
        else
            % Perform rank check for forward path matrices.
            fprintf('Executing else part of the loop\n');
            fname1 = strcat('transformation_layer_forward_', num2str(index));
            fname = strcat(fname1, '.mat');

            if exist(fname, 'file') == 2
                load(fname, 'Learned_Transformation_Matrix_Forward');    
            else
                fprintf('Specified forward path file not found for index: %d\n', index);
            end                                 
            
            % Perform rank check for backward path matrices.
            fprintf('Executing else part of the loop\n');
            fname1 = strcat('transformation_layer_backward_', num2str(index));
            fname = strcat(fname1, '.mat');

            if exist(fname, 'file') == 2
                load(fname, 'Learned_Transformation_Matrix_Backward');    
            else
                fprintf('Specified backward path file not found for index: %d\n', index);
            end          
            
            Transformation_Matrices_Stored(:,:,Transformation_Matrices_Indices) = Learned_Transformation_Matrix_Forward(:,:,1);          
            
            Transformation_Matrices_Indices = Transformation_Matrices_Indices + 1;
            
            Transformation_Matrices_Stored(:,:,Transformation_Matrices_Indices) = Learned_Transformation_Matrix_Backward(:,:,1);    
            
            Transformation_Matrices_Indices = Transformation_Matrices_Indices + 1;
           
            independent = rankOfMatrix(affine_transformation_matrix_forward, Transformation_Matrices_Stored, index+1);
            
            if(independent == false)
                isNewLayerAssigned = false;
                findResult_forward = findWhetherExisting(affine_transformation_matrix_forward, Learned_Transformation_Matrix_Forward);
                findResult_backward = findWhetherExisting(affine_transformation_matrix_forward, Learned_Transformation_Matrix_Backward);
                if(findResult_forward == false && findResult_backward == false)
                    appendedToLayer = index;
                else 
                    % affine_transformation_matrix_forward
                    appendedToLayer = 0;
                end
                break;                
            else
                isNewLayerAssigned = true;
                appendedToLayer = 0;
            end            
        end
        index = index+1;
    end
end

