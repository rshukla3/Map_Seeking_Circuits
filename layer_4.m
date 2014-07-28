function [ scaled_img, scaled_img_vector] = layer_4( input_img, scaleCount, scaleFactor, g, path )
%This module performs scaling (or resize) operation on the input image for
%MSC. 

[m,n] = size(input_img);

scaled_img_vector = logical(zeros(m, n, 2*scaleCount+1));
scaling_sum = g(scaleCount+1)*input_img;

for i= 1:scaleCount
    scale = (i*scaleFactor);
    
    if((g(i) ~=0)&&(strcmpi(path, 'forward')))
        scaled_img_vector(1:m,1:n,i) = g(i)*scaleImg(input_img, (1-scale), (1-scale));
        scaling_sum = scaling_sum + scaled_img_vector(1:m,1:n,i);
    end
    
    if((g(i+scaleCount+1) ~=0)&&(strcmpi(path, 'forward')))
        scaled_img_vector(1:m,1:n,i+scaleCount+1) = g(i+scaleCount+1)*scaleImg(input_img, (1+scale), (1+scale));
        scaling_sum = scaling_sum + scaled_img_vector(1:m,1:n,i+scaleCount+1);
    end
    
    if((g(i) ~=0)&&(strcmpi(path, 'backward')))
        scaled_img_vector(1:m,1:n,i) = g(i)*scaleImg(input_img, (1+scale), (1+scale));
        scaling_sum = scaling_sum + scaled_img_vector(1:m,1:n,i);
    end
    
    if((g(i+scaleCount+1) ~=0)&&(strcmpi(path, 'backward')))
        scaled_img_vector(1:m,1:n,i+scaleCount+1) = g(i+scaleCount+1)*scaleImg(input_img, (1-scale), (1-scale));
        scaling_sum = scaling_sum + scaled_img_vector(1:m,1:n,i+scaleCount+1);
    end
    
end

scaled_img = logical(scaling_sum);
    
end

