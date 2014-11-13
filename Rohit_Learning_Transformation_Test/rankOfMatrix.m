function [ independent ] = rankOfMatrix(affine_transformation_matrix_forward, transformation_forward, layerCount)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    independent = false;
    [m,n,p] = size(transformation_forward);
    for i = 1:p
        tmp = transformation_forward(:,:,i);
        test_transformation(:,i) = tmp(:);
    end
    A = [test_transformation affine_transformation_matrix_forward(:)]
    rankMatrices = rank(test_transformation)
    rankMatrices_learned_transformation = rank([test_transformation affine_transformation_matrix_forward(:)])
    
    if(rankMatrices_learned_transformation > rankMatrices)
        independent = true;
    end
end

