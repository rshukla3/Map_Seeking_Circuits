function [ affine_transformation_matrix ] = learn_new_transformation( Img_PointsOfInterest, Test_Img )
%learn_new_transformation: Given the set of memory corrdinates, learn the
%new affine transformation
%   Img_PointsOfInterest contain the set of coordinates from memory image.
%   Based on these set of memory image coordinates and the new input image,
%   learn the new affine trasformation.

    [Memory_img_Coordinates_Unsorted] = getPointsOfInterest(Img_PointsOfInterest);
    [Test_img_Coordinates_Unsorted] = getPointsOfInterest(Test_Img);
    
    Memory_img_Coordinates_Sorted = sortrows(Memory_img_Coordinates_Unsorted, 3);
    Test_img_Coordinates_Sorted = sortrows(Test_img_Coordinates_Unsorted, 3);
    
    Memory_img_Coordinates_Sorted(:,3) = 1;
    Test_img_Coordinates_Sorted(:,3) = 1;
    
    affine_transformation_matrix = Memory_img_Coordinates_Sorted\Test_img_Coordinates_Sorted;
    disp(affine_transformation_matrix);
    
end

