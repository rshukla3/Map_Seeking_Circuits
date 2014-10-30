function [ isNewLayerAssigned, appendedToLayer ] = checkCombinationOfFunctions( affine_transformation_matrix_forward, layerCount )
%checkCombinationOfFunctions: Checks whether the new learned transformation
%is a combination of already existing layers or is it a new independent
%function.
%   To check whether the new affine transformation matrix is a combination
%   of previously learned independent functions or is it a new learned
%   independent function, we look at the rank of the matrix. Rank will tell
%   us whether this new function is a combination previous independent
%   functions or is it a completely new independent function. 

    isNewLayerAssigned = false;
    appendedToLayer = 1;
    layersSaved = layerCount - 1;
    
    % index variable will parse through or check through every layer and
    % confirm whether this new affine transformation is a combination of
    % previously learned independent functions. 
    index = 1;
    
    while(index <= layersSaved)
        
        % First check whether it is a part of scaling layer.
        if(index == 1)
            fname = 'scaling_transformation_forward.mat';
            if exist(fname, 'file') == 2
                load('scaling_transformation_forward.mat', 'scaling_transformation_forward');    
            else
                fprintf('The selected scaling_transformation_forward.mat file does not exist\n');    
            end
            
            Transformation_Matrices_Stored(:,:,1) = scaling_transformation_forward(:,:,1);
            
            independent = rankOfMatrix(affine_transformation_matrix_forward, Transformation_Matrices_Stored, index+1);
            
            if(independent == false) 
                isNewLayerAssigned = false;
                findResult = findWhetherExisting(affine_transformation_matrix_forward, scaling_transformation_forward);
                fprintf('The value of independent is %d and findResult is %d\n', independent, findResult);
                
                if(findResult == false)
                    appendedToLayer = 1;
                else 
                    scaling_transformation_forward
                    appendedToLayer = 0;
                end
                break;                
            else
                isNewLayerAssigned = true;
                appendedToLayer = 0;
            end            
        else
            fprintf('Executing else part of the loop\n');
            fname1 = strcat('transformation_layer_forward_', num2str(index));
            fname = strcat(fname1, '.mat');

            if exist(fname, 'file') == 2
                load(fname, 'Learned_Transformation_Matrix_Forward');    
            else
                fprintf('Specified file not found for index: %d\n', index);
            end          
            
            [x,y,z] = size(Transformation_Matrices_Stored);
            
            Transformation_Matrices_Stored(:,:,index) = Learned_Transformation_Matrix_Forward(:,:,1);            
           
            independent = rankOfMatrix(affine_transformation_matrix_forward, Transformation_Matrices_Stored, index+1);
            
            if(independent == false)
                isNewLayerAssigned = false;
                findResult = findWhetherExisting(affine_transformation_matrix_forward, Learned_Transformation_Matrix_Forward);
                
                if(findResult == false)
                    appendedToLayer = index;
                else 
                    affine_transformation_matrix_forward
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

