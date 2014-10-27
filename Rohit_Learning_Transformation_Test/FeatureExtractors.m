function [ corners ] = FeatureExtractors( Memory_Img )
Read_Test_Img = imread('pepper_2.jpg');
corners = detectHarrisFeatures(Read_Test_Img);
end

