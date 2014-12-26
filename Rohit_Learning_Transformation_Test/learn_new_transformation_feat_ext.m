function [ affine_transformation_matrix_forward, affine_transformation_matrix_backward ] = learn_new_transformation_feat_ext( Preprocessed_Img, Test_Img )
%learn_new_transformation: Given the set of memory corrdinates, learn the
%new affine transformation
%   Img_PointsOfInterest contain the set of coordinates from memory image.
%   Based on these set of memory image coordinates and the new input image,
%   learn the new affine trasformation.
    
    Memory_Image = imageFeatExtractProcessing(Preprocessed_Img);
    Input_Img = imageFeatExtractProcessing(Test_Img);

    ptsOriginal  = detectSURFFeatures(Memory_Image);
    ptsDistorted = detectSURFFeatures(Input_Img);

    [featuresOriginal,   validPtsOriginal]  = extractFeatures(Memory_Image,  ptsOriginal);
    [featuresDistorted, validPtsDistorted]  = extractFeatures(Input_Img, ptsDistorted);

    indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

    matchedOriginal  = validPtsOriginal(indexPairs(:,1));
    matchedDistorted = validPtsDistorted(indexPairs(:,2));


    [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity');
    
    [iDm, iDn] = size(inlierDistorted.Location);
    [iOm, iOn] = size(inlierOriginal.Location);

    iDistorted = (inlierDistorted.Location - 256.*ones(iDm, iDn));
    iOriginal = (inlierOriginal.Location - 256.*ones(iOm, iOn));

    iDistorted(:,3) = 1;
    iOriginal(:,3) = 1;

    affine_transformation_matrix_forward = round2(iDistorted\iOriginal, 0.01)
    
    [am, an] = size(affine_transformation_matrix_forward);
    
    if(1-abs(affine_transformation_matrix_forward(1,1)) < 0.01)
        affine_transformation_matrix_forward(1,1) = 1;
    end
    
    if(1-abs(affine_transformation_matrix_forward(2,2)) < 0.01)
        affine_transformation_matrix_forward(2,2) = 1;
    end
    

    
    A11 = affine_transformation_matrix_forward(1,1);
    A12 = affine_transformation_matrix_forward(1,2);
    A21 = affine_transformation_matrix_forward(2,1);
    A22 = affine_transformation_matrix_forward(2,2);
    
    affine_transformation_matrix_forward(1,1) = (A11+A22)/2;
    affine_transformation_matrix_forward(2,2) = (A11+A22)/2;
    affine_transformation_matrix_forward(1,2) = (A12+A21)/2;
    affine_transformation_matrix_forward(2,1) = (A12+A21)/2;
    
    for i = 1:am
        for j = 1:an
            if(abs(affine_transformation_matrix_forward(i,j)) < 0.01)
                affine_transformation_matrix_forward(i,j) = 0;
            end
        end
    end
    
    if(abs(affine_transformation_matrix_forward(3,1)) < 5)
        affine_transformation_matrix_forward(3,1) = 0;
    end
    
    if(abs(affine_transformation_matrix_forward(3,2)) < 5)
        affine_transformation_matrix_forward(3,2) = 0;
    end
    
    affine_transformation_matrix_forward
    
    affine_transformation_matrix_backward = round2(iOriginal\iDistorted, 0.01);
    
    [am, an] = size(affine_transformation_matrix_backward);
    
    if(1-abs(affine_transformation_matrix_backward(1,1)) < 0.01)
        affine_transformation_matrix_backward(1,1) = 1;
    end
    
    if(1-abs(affine_transformation_matrix_backward(2,2)) < 0.01)
        affine_transformation_matrix_backward(2,2) = 1;
    end
    
    
    A11 = affine_transformation_matrix_backward(1,1);
    A12 = affine_transformation_matrix_backward(1,2);
    A21 = affine_transformation_matrix_backward(2,1);
    A22 = affine_transformation_matrix_backward(2,2);
    
    affine_transformation_matrix_backward(1,1) = (A11+A22)/2;
    affine_transformation_matrix_backward(2,2) = (A11+A22)/2;
    affine_transformation_matrix_backward(1,2) = (A12+A21)/2;
    affine_transformation_matrix_backward(2,1) = (A12+A21)/2;
    
    for i = 1:am
        for j = 1:an
            if(abs(affine_transformation_matrix_backward(i,j)) < 0.01)
                affine_transformation_matrix_backward(i,j) = 0;
            end
        end
    end
    
    if(abs(affine_transformation_matrix_backward(3,1)) < 5)
        affine_transformation_matrix_backward(3,1) = 0;
    end
    
    if(abs(affine_transformation_matrix_backward(3,2)) < 5)
        affine_transformation_matrix_backward(3,2) = 0;
    end
    affine_transformation_matrix_backward
    
end

