%function [ output_img ] = AssignPointsOfInterest( input_img )
%AssignPointsOfInterest This function assigns points of interest to input
%image
%   Mark areas of interest (or regions of intest in the input image). 

%% Test I

% As a test see whether we are able to identify new coordinates in the ROI
% using in-built ROI functions.
clc;
clear all;
close all;

%% Assign x and y coordinates that belong to areas of interest.

x(1) = 251;
x(2) = 230;
x(3) = 236;
x(4) = 266;
x(5) = 202;
x(6) = 316;
x(7) = 315;
x(8) = 211;
x(9) = 283;
x(10) = 254;
x(11) = 293;
x(12) = 245;
x(13) = 266;
x(14) = 286;

y(1) = 189;
y(2) = 342;
y(3) = 200;
y(4) = 201;
y(5) = 252;
y(6) = 240;
y(7) = 267;
y(8) = 317;
y(9) = 337;
y(10) = 343;
y(11) = 306;
y(12) = 210;
y(13) = 214;
y(14) = 234;
[Test_Img] = imagePreProcessing('pepper_2.jpg');
new_img = zeros(size(Test_Img));
h_im = imshow(Test_Img);
e = impoint(gca, x(1), y(1));
BW = createMask(e,h_im);
pos = getPosition(e);
new_img = new_img | (BW.*255);
for i = 2:14
    setPosition(e, x(i), y(i));
    BW = createMask(e,h_im);
    new_img = new_img | BW.*(255-i+1);
end
figure(3);
imshow(new_img);

%end

