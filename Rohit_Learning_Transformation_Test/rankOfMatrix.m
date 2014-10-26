function [ independent ] = rankOfMatrix(affine_transformation_matrix_forward, scaling_transformation_forward)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    independent = false;

    rankColumn1 = rank([affine_transformation_matrix_forward(:,1) scaling_transformation_forward(:,1)]);
    rankColumn2 = rank([affine_transformation_matrix_forward(:,2) scaling_transformation_forward(:,2)]);
    
    if(rankColumn1 == 2 || rankColumn2 == 2)
        independent = true;
    end
end

