function [ existing ] = findWhetherExisting(affine_transformation_matrix_forward, transformation_forward)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    existing = false;
    
    if(find(transformation_forward == affine_transformation_matrix_forward))
        existing = true;
    end
end

