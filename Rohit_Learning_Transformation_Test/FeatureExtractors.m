function [ points ] = FeatureExtractors( Memory_Img )
points = detectFASTFeatures(double(Memory_Img));
end

