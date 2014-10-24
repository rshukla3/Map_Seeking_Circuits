function [ Scaled_Img, Transformation_Vector ] = layer_scaling( Test_Img_Input,  scaleCount, g, path)
% layer_1: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

if(strcmpi(path, 'forward'))
    fname = 'scaling_transformation_forward.mat';
    if exist(fname, 'file') == 2
        load('scaling_transformation_forward.mat', 'scaling_transformation_forward');    
    else
        fprintf('The selected scaling_transformation_forward.mat file does not exist\n');    
        exit(0);
    end
end

if(strcmpi(path, 'backward'))
    fname = 'scaling_transformation_backward.mat';
    if exist(fname, 'file') == 2
        load('scaling_transformation_backward.mat', 'scaling_transformation_backward');    
    else
        fprintf('The selected scaling_transformation_backward.mat file does not exist\n');    
        exit(0);
    end
end

Test_Img = single(Test_Img_Input);

[m,n] = size(Test_Img);

Transformation_Vector = single(zeros(m,n,scaleCount));

% Value of f0 is 0. So the vector T(f0) should be a zero vector.
%Transformation_Vector_Zero = Transformation_Vector;

Scale_Img_sum = g(1)*Test_Img;
Transformation_Vector(1:m,1:n,1) = Scale_Img_sum;

for i = 2:scaleCount
    
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))            
            Transformation_Vector(1:m,1:n,i) = (g(i)*scale_img(Test_Img, scaling_transformation_forward(:,:,i)));
            Scale_Img_sum = Scale_Img_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            Scale_Img_sum = Scale_Img_sum + (g(i)*scale_img(Test_Img, scaling_transformation_backward(:,:,i)));
        end        
        
end

Scaled_Img = single(Scale_Img_sum); 
end

