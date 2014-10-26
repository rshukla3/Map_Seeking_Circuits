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
    appendedToLayer = 0;
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
            
            independent = rankOfMatrix(affine_transformation_matrix_forward, scaling_transformation_forward);
            
            if(independent == true)
                isNewLayerAssigned = true;
            else
                appendedToLayer = 1;
            end            
        end
        index = index+1;
    end
end

