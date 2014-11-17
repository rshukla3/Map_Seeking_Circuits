function [ independent ] = rankOfMatrix(affine_transformation_matrix_forward, transformation_forward, layerCount)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    independent = false;
    [m,n,p] = size(transformation_forward);
    Identity_Matrix = [1 0 0; 0 1 0; 0 0 1];
    test_transformation(:,1) = Identity_Matrix(:);
    for i = 1:p
        tmp = transformation_forward(:,:,i); 
        determinant_transformation(i) = det(tmp);
        if(abs(determinant_transformation(i)-1) < 0.01)
            determinant_transformation(i) = 1;
        end
        test_transformation(:,i+1) = tmp(:);        
    end    
    
    A = [test_transformation affine_transformation_matrix_forward(:)]
    rankMatrices = rank(test_transformation)
    rankMatrices_learned_transformation = rank([test_transformation affine_transformation_matrix_forward(:)])
    
    determinant_affine_transformation = (det(affine_transformation_matrix_forward));
    
    if(abs(determinant_affine_transformation-1) < 0.01)
        determinant_affine_transformation = 1;
    end
    determinant_transformation(1)
    determinant_affine_transformation
    if((determinant_transformation(1) == 1) && determinant_affine_transformation == 1)
        if(rankMatrices_learned_transformation > rankMatrices)
            independent = true;
        end
    elseif(determinant_affine_transformation ~= 1)
        fprintf('Determinant is not equal to one\n');
        if(rankMatrices_learned_transformation > rankMatrices)
            independent = true;
        end
    end
end

