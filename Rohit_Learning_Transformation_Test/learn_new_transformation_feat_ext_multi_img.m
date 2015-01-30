function [ affine_transformation_matrix_forward, affine_transformation_matrix_backward, objectFound ] = learn_new_transformation_feat_ext_multi_img( Test_Img, Edge_Detected_Img )
%learn_new_transformation: Given the set of memory corrdinates, learn the
%new affine transformation
%   Img_PointsOfInterest contain the set of coordinates from memory image.
%   Based on these set of memory image coordinates and the new input image,
%   learn the new affine trasformation.
    
    fname = strcat('learn_mem_img', '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'learn_mem_img');   
        [rows,columns,memory_units] = size(learn_mem_img);
    else
        fprintf('Specified file not found in forward path for layer_mem_img\n');
    end
    
    fname = strcat('mem_img', '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'mem_img');   
        [rows,columns,memory_units_edge_detected] = size(mem_img);
    else
        fprintf('Specified file not found in forward path for mem_img\n');
    end
    
    [lm, ln, memory_units] = size(learn_mem_img);
    
    objectFound = false;
    affine_transformation_matrix_forward = [1 0 0; 0 1 0; 0 0 1];
    affine_transformation_matrix_backward = [1 0 0; 0 1 0; 0 0 1];
    mu = 0;
    while (mu < memory_units && objectFound == false)
        mu = mu + 1;
        Preprocessed_Img(1:lm, 1:ln) = learn_mem_img(1:lm, 1:ln, mu);
        clear ptsOriginal;
        clear ptsDistorted;
        ptsOriginal  = detectSURFFeatures(Preprocessed_Img);
        ptsDistorted = detectSURFFeatures(Test_Img);

        [featuresOriginal,   validPtsOriginal]  = extractFeatures(Preprocessed_Img,  ptsOriginal);
        [featuresDistorted, validPtsDistorted]  = extractFeatures(Test_Img, ptsDistorted);

        indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
        
        matchedOriginal  = validPtsOriginal(indexPairs(:,1));
        matchedDistorted = validPtsDistorted(indexPairs(:,2));
        
        [mOm, mOn] = size(matchedOriginal)
        [mDm, mDn] = size(matchedDistorted)
        
        if(mOm >3 && mDm > 3)
            [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity');
            figure(4);
            showMatchedFeatures(Preprocessed_Img,Test_Img, inlierOriginal, inlierDistorted);
            [iDm, iDn] = size(inlierDistorted.Location);
            [iOm, iOn] = size(inlierOriginal.Location);
            T1 = tform.invert.T
            ss = T1(2,1);
            sc = T1(1,1);
            T1_scale_recovered = round2(sqrt(ss*ss + sc*sc), 0.1);
            T1_theta_recovered = round2(atan2(ss,sc)*180/pi, 1);
%             if((T1_scale_recovered <= 1.1 && T1_scale_recovered >= 0.9 && abs(T1_theta_recovered) > 5)||(T1_scale_recovered > 1.1 && T1_scale_recovered < 0.9 && abs(T1_theta_recovered) < 5) || (T1_scale_recovered <= 1.1 && T1_scale_recovered >= 0.9 && abs(T1_theta_recovered) >= 0 && abs(T1_theta_recovered <= 2)))
    
%                 objectFound = true;
                
                iDistorted_tmp = (inlierDistorted.Location - 256.*ones(iDm, iDn));
                iOriginal_tmp = (inlierOriginal.Location - 256.*ones(iOm, iOn));

                iDistorted_tmp(:,3) = 1;
                iOriginal_tmp(:,3) = 1;
                
                [iDm, iDn] = size(iDistorted_tmp);                
                iDistorted(1:iDm,1) = iDistorted_tmp(:,2);
                iDistorted(1:iDm,2) = iDistorted_tmp(:,1);
                iDistorted(1:iDm,3) = iDistorted_tmp(:,3);
                
                [iOm, iOn] = size(iOriginal_tmp);
                iOriginal(1:iOm,1) = iOriginal_tmp(:,2);
                iOriginal(1:iOm,2) = iOriginal_tmp(:,1);
                iOriginal(1:iOm,3) = iOriginal_tmp(:,3);

                affine_transformation_matrix_forward = round2(iDistorted\iOriginal, 0.01)
                if(~isnan(affine_transformation_matrix_forward))

                    [am, an] = size(affine_transformation_matrix_forward);

                    if(abs(1-abs(affine_transformation_matrix_forward(1,1))) < 0.01)
                        affine_transformation_matrix_forward(1,1) = 1;
                    end

                    if(abs(1-abs(affine_transformation_matrix_forward(2,2))) < 0.01)
                        affine_transformation_matrix_forward(2,2) = 1;
                    end

                    if(abs(affine_transformation_matrix_forward(2,1)) < 0.1)
                        affine_transformation_matrix_forward(2,1) = 0;
                    end

                    if(abs(affine_transformation_matrix_forward(1,2)) < 0.1)
                        affine_transformation_matrix_forward(1,2) = 0;
                    end

                    A11 = affine_transformation_matrix_forward(1,1);
                    A12 = affine_transformation_matrix_forward(1,2);
                    A21 = affine_transformation_matrix_forward(2,1);
                    A22 = affine_transformation_matrix_forward(2,2);

                    affine_transformation_matrix_forward(1,1) = sign(A11)*round2((abs(A11)+abs(A22))/2,0.01);
                    affine_transformation_matrix_forward(2,2) = sign(A22)*round2((abs(A11)+abs(A22))/2,0.01);
                    affine_transformation_matrix_forward(1,2) = sign(A12)*round2((abs(A12)+abs(A21))/2,0.01);
                    affine_transformation_matrix_forward(2,1) = sign(A21)*round2((abs(A12)+abs(A21))/2,0.01);

                    for i = 1:am
                        for j = 1:an
                            if(abs(affine_transformation_matrix_forward(i,j)) < 0.01)
                                affine_transformation_matrix_forward(i,j) = 0;
                            end
                        end
                    end
    %                 A31 = affine_transformation_matrix_forward(3,1);
    %                 A32 = affine_transformation_matrix_forward(3,2);
    %                 affine_transformation_matrix_forward(3,1) = -A32;
    %                 affine_transformation_matrix_forward(3,2) = -A31;
                    if(abs(affine_transformation_matrix_forward(3,1)) < 5)
                        affine_transformation_matrix_forward(3,1) = 0;
                    end

                    if(abs(affine_transformation_matrix_forward(3,2)) < 5)
                        affine_transformation_matrix_forward(3,2) = 0;
                    end

                    affine_transformation_matrix_forward

                    % Get the new image after applying this learnt
                    % transformation and see whether it matches the image in
                    % the memory.

                    % coordinates those positions in the image that have non-zero pixel values
                    % and the intensity or the pixel value.
                    [m,n] = size(Test_Img);
                    [coordinates]= getPointsOfInterest(Edge_Detected_Img); 
                    T = (img_transform(coordinates, m, n, affine_transformation_matrix_forward));

                    D_1 = dotproduct(T,mem_img(:,:,mu))

                else
                     D_1 = 0;
                end
                
%                 [coordinates]= getPointsOfInterest(mem_img(:,:,mu)); 
%                 T = (img_transform(coordinates, m, n, affine_transformation_matrix_forward));
%                 
%                 D_2 = dotproduct(Edge_Detected_Img,T)
                
            if(D_1>20)
                objectFound = true;
                ss = affine_transformation_matrix_forward(2,1);
                sc = affine_transformation_matrix_forward(1,1);
                scale_recovered = sqrt(ss*ss + sc*sc);
                theta_recovered = atan2(ss,sc)*180/pi;
                affine_transformation_matrix_backward = round2(iOriginal\iDistorted, 0.01);

                [am, an] = size(affine_transformation_matrix_backward);

                if(abs(1-abs(affine_transformation_matrix_backward(1,1))) < 0.01)
                    affine_transformation_matrix_backward(1,1) = 1;
                end

                if(abs(1-abs(affine_transformation_matrix_backward(2,2))) < 0.01)
                    affine_transformation_matrix_backward(2,2) = 1;
                end
                
                if(abs(affine_transformation_matrix_backward(2,1)) < 0.1)
                    affine_transformation_matrix_backward(2,1) = 0;
                end

                if(abs(affine_transformation_matrix_backward(1,2)) < 0.1)
                    affine_transformation_matrix_backward(1,2) = 0;
                end

                A11 = affine_transformation_matrix_backward(1,1)
                A12 = affine_transformation_matrix_backward(1,2);
                A21 = affine_transformation_matrix_backward(2,1);
                A22 = affine_transformation_matrix_backward(2,2)

                affine_transformation_matrix_backward(1,1) = sign(A11)*round2((abs(A11)+abs(A22))/2,0.01);
                affine_transformation_matrix_backward(2,2) = sign(A22)*round2((abs(A11)+abs(A22))/2, 0.01);
                affine_transformation_matrix_backward(1,2) = sign(A12)*round2((abs(A12)+abs(A21))/2,0.01);
                affine_transformation_matrix_backward(2,1) = sign(A21)*round2((abs(A12)+abs(A21))/2,0.01);

                for i = 1:am
                    for j = 1:an
                        if(abs(affine_transformation_matrix_backward(i,j)) < 0.01)
                            affine_transformation_matrix_backward(i,j) = 0;
                        end
                    end
                end
%                 A31 = affine_transformation_matrix_backward(3,1);
%                 A32 = affine_transformation_matrix_backward(3,2);
%                 affine_transformation_matrix_backward(3,1) = -A32;
%                 affine_transformation_matrix_backward(3,2) = -A31;
                if(abs(affine_transformation_matrix_backward(3,1)) < 5)
                    affine_transformation_matrix_backward(3,1) = 0;
                end

                if(abs(affine_transformation_matrix_backward(3,2)) < 5)
                    affine_transformation_matrix_backward(3,2) = 0;
                end

                affine_transformation_matrix_backward
                break;
%                 if(D_2 > 20 && D_1 < 20)
%                     F = affine_transformation_matrix_forward;
%                     B = affine_transformation_matrix_backward;
%                     
%                     affine_transformation_matrix_forward = B;
%                     affine_transformation_matrix_backward = F;
%                 end
            end
        end
    end
    objectFound
    return;
    if(objectFound == false)
        % If the input object was not found, then,
        % store the new object in the memory.
        learn_mem_img(:,:,memory_units+1) = Test_Img;
        save('learn_mem_img.mat', 'learn_mem_img');        
        load('mem_img.mat', 'mem_img'); 
        [m,n,Values] = size(mem_img);
        mem_img(:,:,Values+1) = Edge_Detected_Img;
        save('mem_img.mat', 'mem_img');
    end
    
end

