function [ affine_transformation_matrix_forward, affine_transformation_matrix_backward ] = learn_new_transformation_feat_ext( Preprocessed_Img, Test_Img )
%learn_new_transformation: Given the set of memory corrdinates, learn the
%new affine transformation
%   Img_PointsOfInterest contain the set of coordinates from memory image.
%   Based on these set of memory image coordinates and the new input image,
%   learn the new affine trasformation.

    ptsOriginal  = detectSURFFeatures(Preprocessed_Img);
    ptsDistorted = detectSURFFeatures(Test_Img);

    [featuresOriginal,   validPtsOriginal]  = extractFeatures(Preprocessed_Img,  ptsOriginal);
    [featuresDistorted, validPtsDistorted]  = extractFeatures(Test_Img, ptsDistorted);

    indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

    matchedOriginal  = validPtsOriginal(indexPairs(:,1));
    matchedDistorted = validPtsDistorted(indexPairs(:,2));


    [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity');
    figure(4);
    showMatchedFeatures(Preprocessed_Img,Test_Img, inlierOriginal, inlierDistorted);
    title('Matching points (inliers only)');
    legend('ptsOriginal','ptsDistorted');
    figure(1);
    imshow(Test_Img); hold on;
    plot(inlierDistorted.selectStrongest(10));

    figure(2);
    imshow(Preprocessed_Img); hold on;
    plot(inlierOriginal.selectStrongest(10));

    Tinv  = tform.invert.T;
    Memory_img_Coordinates_Sorted(:,3) = 1;
    Test_img_Coordinates_Sorted(:,3) = 1;
    
    affine_transformation_matrix_forward = Test_img_Coordinates_Sorted\Memory_img_Coordinates_Sorted;
    
    [am, an] = size(affine_transformation_matrix_forward);
    
%     for i = 1:am
%         for j = 1:an
%             if(abs(affine_transformation_matrix_forward(i,j)) < 0.0001)
%                 affine_transformation_matrix_forward(i,j) = 0;
%             end
%             if(abs(affine_transformation_matrix_forward(i,j)-1) < 0.0001)
%                 affine_transformation_matrix_forward(i,j) = 1;
%             end
%         end
%     end

    
% If the the third row of transformation matrix has small elements then
% change to zero. This is because less than one pixel translation does not
% make sense. This is an approximation done from MATLAB's side.

%     if(abs(affine_transformation_matrix_forward(3,1)) < 1)
%         affine_transformation_matrix_forward(3,1) = 0;
%     end
%     
%     if(abs(affine_transformation_matrix_forward(3,2)) < 1)
%         affine_transformation_matrix_forward(3,2) = 0;
%     end
    
% Another problem with affine transformations is that due to MATLAB's
% approximations there are very small values that are coming. These
% approximations are messing up with scaling and rotation matrix values.
% Thus, to resolve this problem I downloaded round2() function that lets me
% choose till which decimal place I want to round or approximate my value.

% So that I do not mess up between scaling and rotation values I will first
% round (1,2) and (2,1) to check whether it is scaling or rotation. If it
% is scaling then these two values would be zero, otherwise, for rotation
% these two elements will have non-zero value.
    R1 = round2(affine_transformation_matrix_forward(1,2),0.01);
    R2 = round2(affine_transformation_matrix_forward(2,1),0.01);
    affine_transformation_matrix_forward(1,3) = round2(affine_transformation_matrix_forward(1,3),0.01);
    affine_transformation_matrix_forward(2,3) = round2(affine_transformation_matrix_forward(2,3),0.01);
    if(abs(affine_transformation_matrix_forward(3,1)) < 1)
        affine_transformation_matrix_forward(3,1) = 0;
    end
    
    if(abs(affine_transformation_matrix_forward(3,2)) < 1)
        affine_transformation_matrix_forward(3,2) = 0;
    end
    
    if(R1 == 0 && R2 == 0)
        affine_transformation_matrix_forward(1,2) = round2(affine_transformation_matrix_forward(1,2),0.01);
        affine_transformation_matrix_forward(2,1) = round2(affine_transformation_matrix_forward(2,1),0.01);
        affine_transformation_matrix_forward(1,1) = round2(affine_transformation_matrix_forward(1,1),0.01);
        affine_transformation_matrix_forward(2,2) = round2(affine_transformation_matrix_forward(2,2),0.01);
    else
        affine_transformation_matrix_forward(1,2) = round2(affine_transformation_matrix_forward(1,2),0.01);
        affine_transformation_matrix_forward(2,1) = round2(affine_transformation_matrix_forward(2,1),0.01);
        affine_transformation_matrix_forward(1,1) = round2(affine_transformation_matrix_forward(1,1),0.01);
        affine_transformation_matrix_forward(2,2) = round2(affine_transformation_matrix_forward(2,2),0.01);
    end
    affine_transformation_matrix_forward
    
    affine_transformation_matrix_backward = Memory_img_Coordinates_Sorted\Test_img_Coordinates_Sorted;
    
    [am, an] = size(affine_transformation_matrix_backward);
    
%     for i = 1:am
%         for j = 1:an
%             if(abs(affine_transformation_matrix_backward(i,j)) < 0.0001)
%                 affine_transformation_matrix_backward(i,j) = 0;
%             end
%             if(abs(affine_transformation_matrix_backward(i,j)-1) < 0.0001)
%                 affine_transformation_matrix_backward(i,j) = 1;
%             end
%         end
%     end
    
% If the the third row of transformation matrix has small elements then
% change to zero. This is because less than one pixel translation does not
% make sense. This is an approximation done from MATLAB's side.

%     if(abs(affine_transformation_matrix_backward(3,1)) < 1)
%         affine_transformation_matrix_backward(3,1) = 0;
%     end
%     
%     if(abs(affine_transformation_matrix_backward(3,2)) < 1)
%         affine_transformation_matrix_backward(3,2) = 0;
%     end
    
    R1 = round2(affine_transformation_matrix_backward(1,2),0.01);
    R2 = round2(affine_transformation_matrix_backward(2,1),0.01);
    affine_transformation_matrix_backward(1,3) = round2(affine_transformation_matrix_backward(1,3),0.01);
    affine_transformation_matrix_backward(2,3) = round2(affine_transformation_matrix_backward(2,3),0.01);
    if(abs(affine_transformation_matrix_backward(3,1)) < 1)
        affine_transformation_matrix_backward(3,1) = 0;
    end
    
    if(abs(affine_transformation_matrix_backward(3,2)) < 1)
        affine_transformation_matrix_backward(3,2) = 0;
    end
    if(R1 == 0 && R2 == 0)
        affine_transformation_matrix_backward(1,2) = round2(affine_transformation_matrix_backward(1,2),0.01);
        affine_transformation_matrix_backward(2,1) = round2(affine_transformation_matrix_backward(2,1),0.01);
        affine_transformation_matrix_backward(1,1) = round2(affine_transformation_matrix_backward(1,1),0.01);
        affine_transformation_matrix_backward(2,2) = round2(affine_transformation_matrix_backward(2,2),0.01);
    else
        affine_transformation_matrix_backward(1,2) = round2(affine_transformation_matrix_backward(1,2),0.01);
        affine_transformation_matrix_backward(2,1) = round2(affine_transformation_matrix_backward(2,1),0.01);
        affine_transformation_matrix_backward(1,1) = round2(affine_transformation_matrix_backward(1,1),0.01);
        affine_transformation_matrix_backward(2,2) = round2(affine_transformation_matrix_backward(2,2),0.01);
    end
    
    affine_transformation_matrix_backward
    
end

