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
    
    rankMatrices = rank([affine_transformation_matrix_forward(:) test_transformation]);
    
    if(rankMatrices == layerCount)
        independent = true;
    end
end

