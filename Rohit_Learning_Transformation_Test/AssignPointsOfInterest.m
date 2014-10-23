%function [ output_img ] = AssignPointsOfInterest( input_img )
%AssignPointsOfInterest This function assigns points of interest to input
%image
%   Mark areas of interest (or regions of intest in the input image). 

%% Test I

% As a test see whether we are able to identify new coordinates in the ROI
% using in-built ROI functions.

[Test_Img] = imagePreProcessing('pepper_2.jpg');

h_im = imshow(Test_Img);
e = impoint(gca,251, 189);
BW = createMask(e,h_im);
pos = getPosition(e);
setPosition(e, 230, 342);
pos2 = getPosition(e);

%end

