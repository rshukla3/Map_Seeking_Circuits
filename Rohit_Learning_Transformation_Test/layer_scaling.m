function [ Scaled_Img, Transformation_Vector ] = layer_scaling( Test_Img_Input,  g, path)
% layer_scaling: In this layer of map seeking circuits we perform image
% scaling.

if(strcmpi(path, 'forward'))
    fname = 'scaling_transformation_forward.mat';
    if exist(fname, 'file') == 2
        load('scaling_transformation_forward.mat', 'scaling_transformation_forward');    
        [rows,columns,scaleCount] = size(scaling_transformation_forward);
    else
        fprintf('The selected scaling_transformation_forward.mat file does not exist\n');    
        %exit(0);
    end
end

if(strcmpi(path, 'backward'))
    fname = 'scaling_transformation_backward.mat';
    if exist(fname, 'file') == 2
        load('scaling_transformation_backward.mat', 'scaling_transformation_backward');    
        [rows,columns,scaleCount] = size(scaling_transformation_backward);
    else
        fprintf('The selected scaling_transformation_backward.mat file does not exist\n');    
        %exit(0);
    end
end

Test_Img = single(Test_Img_Input);

[m,n] = size(Test_Img);

Transformation_Vector = single(zeros(m,n,scaleCount));

Scale_Img_sum = g(1)*Test_Img;
Transformation_Vector(1:m,1:n,1) = Scale_Img_sum;

% coordinates those positions in the image that have non-zero pixel values
% and the intensity or the pixel value.
[coordinates]= getPointsOfInterest(Test_Img); 

for i = 2:scaleCount   
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))            
            Transformation_Vector(1:m,1:n,i) = (g(i)*scale_img(coordinates, m, n, scaling_transformation_forward(:,:,i)));
            Scale_Img_sum = Scale_Img_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            Scale_Img_sum = Scale_Img_sum + (g(i)*scale_img(coordinates, m, n, scaling_transformation_backward(:,:,i)));
        end        
        
end

Scaled_Img = single(Scale_Img_sum); 
end

