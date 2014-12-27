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
        determinant_transformation(i) = round2(det(tmp),0.1);
        if(abs(determinant_transformation(i)-1) < 0.01)
            determinant_transformation(i) = 1;
        end
        
        test_transformation_1 = tmp(1,:);        
        test_transformation_2 = tmp(2,:);        
        test_transformation_3 = tmp(3,:);  
        
        test_transformation(1:3,i+1) = tmp(1,:);        
        test_transformation(4:6,i+1) = tmp(2,:);        
        test_transformation(7:9,i+1) = tmp(3,:);        
    end    
    
    affine_transformation_tmp(1:3,1) = affine_transformation_matrix_forward(1,:);
    affine_transformation_tmp(4:6,1) = affine_transformation_matrix_forward(2,:);
    affine_transformation_tmp(7:9,1) = affine_transformation_matrix_forward(3,:);
    
    affine_transformation_tmp_1 = affine_transformation_matrix_forward(1,:);
    affine_transformation_tmp_2 = affine_transformation_matrix_forward(2,:);
    affine_transformation_tmp_3 = affine_transformation_matrix_forward(3,:);
    
    A = [test_transformation affine_transformation_tmp]
    
    A_1 = [test_transformation_1 affine_transformation_tmp_1]
    A_2 = [test_transformation_2 affine_transformation_tmp_2]
    A_3 = [test_transformation_3 affine_transformation_tmp_3]
    
    % rref calculates reduced row echelon value of the matrix. The purpose of
    % adding this function was to get correct value of rank of the matrix.
    % Due to approximation errors rank is coming out to be something
    % strange or a wrong value. 
    % Even after calculating rref values of the matrix, rank is still
    % wrong. This might be due to tol or tolerance that is calculated for
    % the rank. To take of this issue I've added threshold 0.01 for
    % tolerance. Since we are considering values till second decimal place,
    % that is why I am choosing the tolerance value to be 0.01.
    test_transformation_row_echelon = rref(test_transformation);    
    rankMatrices = rank(test_transformation_row_echelon, 0.01)
    affine_transformation_row_echelon = rref([test_transformation affine_transformation_tmp]);
    rankMatrices_learned_transformation = rank(affine_transformation_row_echelon, 0.01)
    
    test_transformation_row_echelon_1 = rref(test_transformation_1);    
    rankMatrices_1 = rank(test_transformation_row_echelon_1, 0.01)
    affine_transformation_row_echelon_1 = rref([test_transformation_1 affine_transformation_tmp_1]);
    rankMatrices_learned_transformation_1 = rank(affine_transformation_row_echelon_1, 0.01)
    
    test_transformation_row_echelon_2 = rref(test_transformation_2);    
    rankMatrices_2 = rank(test_transformation_row_echelon_2, 0.01)
    affine_transformation_row_echelon_2 = rref([test_transformation_2 affine_transformation_tmp_2]);
    rankMatrices_learned_transformation_2 = rank(affine_transformation_row_echelon_2, 0.01)
    
    test_transformation_row_echelon_3 = rref(test_transformation_3);    
    rankMatrices_3 = rank(test_transformation_row_echelon_3, 0.01)
    affine_transformation_row_echelon_3 = rref([test_transformation_3 affine_transformation_tmp_3]);
    rankMatrices_learned_transformation_3 = rank(affine_transformation_row_echelon_3, 0.01)
    
    % Determinant is used to separate scaling function from all the other
    % functions. For all of the other functions value of det is one,
    % whereas, for scaling it is something different.
    determinant_affine_transformation = round2(det(affine_transformation_matrix_forward),0.1);
    
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
    elseif(determinant_affine_transformation == 1 && determinant_transformation(1) ~= 1)
        fprintf('Determinant stored transformation is not equal to one\n');
        independent = true;
    end
end

