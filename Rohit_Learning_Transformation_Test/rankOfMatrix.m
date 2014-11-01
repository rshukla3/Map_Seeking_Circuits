function [ independent ] = rankOfMatrix(affine_transformation_matrix_forward, transformation_forward, layerCount)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    independent = false;
    [m,n,p] = size(transformation_forward);
    for i = 1:p
        test_transformation_column_1(:,i) = transformation_forward(:,1,i);
    end
    contatenated_matrix_1 = [affine_transformation_matrix_forward(:,1) test_transformation_column_1]
    rankColumn1 = rank([affine_transformation_matrix_forward(:,1) test_transformation_column_1]);
    rankColumn1
    for i = 1:p
        test_transformation_column_2(:,i) = transformation_forward(:,2,i);
    end
    contatenated_matrix_2 = [affine_transformation_matrix_forward(:,2) test_transformation_column_2]
    rankColumn2 = rank([affine_transformation_matrix_forward(:,2) test_transformation_column_2]);
    rankColumn2
    if(rankColumn1 == layerCount || rankColumn2 == layerCount)
        independent = true;
    end
end

