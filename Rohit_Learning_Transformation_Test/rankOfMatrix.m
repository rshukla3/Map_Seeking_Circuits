function [ independent ] = rankOfMatrix(affine_transformation_matrix_forward, transformation_forward, layerCount)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    independent = false;
    [m,n,p] = size(transformation_forward);
    for i = 1:p
        tmp = transformation_forward(:,:,i);
        tmp_1 = tmp(1,:);
        tmp_2 = tmp(2,:);
        tmp_3 = tmp(3,:);
        test_transformation_1(:,i) = tmp_1(:);
        test_transformation_2(:,i) = tmp_2(:);
        test_transformation_3(:,i) = tmp_3(:);
    end
    affine_tmp_1 = affine_transformation_matrix_forward(1,:);
    affine_tmp_2 = affine_transformation_matrix_forward(2,:);
    affine_tmp_3 = affine_transformation_matrix_forward(3,:);
    A_1 = [test_transformation_1 affine_tmp_1(:)]
    rankMatrices_1 = rank(test_transformation_1)
    rankMatrices_learned_transformation_1 = rank([test_transformation_1 affine_tmp_1(:)])
    
    A_2 = [test_transformation_2 affine_tmp_2(:)]
    rankMatrices_2 = rank(test_transformation_2)
    rankMatrices_learned_transformation_2 = rank([test_transformation_2 affine_tmp_2(:)])
    
    A_3 = [test_transformation_3 affine_tmp_3(:)]
    rankMatrices_3 = rank(test_transformation_3)
    rankMatrices_learned_transformation_3 = rank([test_transformation_3 affine_tmp_3(:)])
    
    if(rankMatrices_learned_transformation_1 > rankMatrices_1 || rankMatrices_learned_transformation_2 > rankMatrices_2 || rankMatrices_learned_transformation_3 > rankMatrices_3)
        independent = true;
    end
end

