function [ scaled_img, scaled_img_vector, q_scaling] = layer_4( input_img, scaleCount, scaleFactor, g, path )
%This module performs scaling (or resize) operation on the input image for
%MSC. 

[m,n] = size(input_img);
input_img = single(input_img);
scaled_img_vector = single(zeros(m, n, 2*scaleCount+1));
q_scaling = single(zeros(1,2*scaleCount+1));

scaling_sum = g(scaleCount+1)*input_img;
scaled_img_vector(1:m, 1:n, scaleCount+1) = scaling_sum;
q_scaling(scaleCount+1) = 1;

for i= 1:scaleCount
    scale = (i*scaleFactor);
    
    if((g(i) ~=0)&&(strcmpi(path, 'forward'))&&(1-scale>0))
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
        q_scaling(i) = 1+1*scale;
    end
    
    if((g(i+scaleCount+1) ~=0)&&(strcmpi(path, 'backward'))&&(1-scale>0))
        scaled_img_vector(1:m,1:n,i+scaleCount+1) = g(i+scaleCount+1)*scaleImg(input_img, (1-scale), (1-scale));
        scaling_sum = scaling_sum + scaled_img_vector(1:m,1:n,i+scaleCount+1);
        q_scaling(i+scaleCount+1) = 1-1*scale;
    end
    
end

scaled_img = single(scaling_sum);
    
end

