function [ independent ] = rankOfMatrix(affine_transformation_matrix_forward, transformation_forward, layerCount)
%rankOfMatrix: Caclualtes the rank of the matrix to check for independent
%layers in MSC.
%   Detailed explanation goes here
    independent = false;
    [m,n,p] = size(transformation_forward);
    Identity_Matrix = [1 0 0; 0 1 0; 0 0 1];
    test_transformation(:,1) = Identity_Matrix(:);
%     test_transformation(:,2) = Identity_Matrix(:);
    for i = 1:p
        tmp = transformation_forward(:,:,i); 
        determinant_transformation(i) = det(tmp);
        if(abs(determinant_transformation(i)-1) < 0.01)
            determinant_transformation(i) = 1;
        end
        test_transformation(1:3,i+1) = tmp(1,:);        
        test_transformation(4:6,i+1) = tmp(2,:);        
        test_transformation(7:9,i+1) = tmp(3,:);        
    end    
    
    affine_transformation_tmp(1:3,1) = affine_transformation_matrix_forward(1,:);
    affine_transformation_tmp(4:6,1) = affine_transformation_matrix_forward(2,:);
    affine_transformation_tmp(7:9,1) = affine_transformation_matrix_forward(3,:);
    A = [test_transformation affine_transformation_tmp]
    test_transformation_row_echelon = rref(test_transformation);
    rankMatrices = rank(test_transformation_row_echelon)
    affine_transformation_row_echelon = rref([test_transformation affine_transformation_tmp]);
    rankMatrices_learned_transformation = rank(affine_transformation_row_echelon)
    
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
    elseif(determinant_affine_transformation ~= 1 && determinant_transformation(1) ~= 1)
        fprintf('Both the determinants is not equal to one\n');
        if(rankMatrices_learned_transformation > rankMatrices)
            independent = true;
        end
    elseif(determinant_affine_transformation ~= 1 && determinant_transformation(1) == 1)
        fprintf('Determinant affine transformation is not equal to one\n');
        independent = true;
    end
end

