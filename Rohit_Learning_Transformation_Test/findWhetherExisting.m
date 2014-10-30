function [ existing ] = findWhetherExisting(affine_transformation_matrix_forward, transformation_forward)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    existing = false;
    
    [x,y,z] = size(transformation_forward);
    
    for i = 1:z
        if(isequal(transformation_forward(:,:,i),affine_transformation_matrix_forward))
            existing = true;
            break;
        end
    end
end

