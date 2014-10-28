function [ Layer_Img, Transformation_Vector ] = layer_1( Test_Img_Input,  g, path)
% layer_scaling: In this layer of map seeking circuits we perform image
% scaling.

if(strcmpi(path, 'forward'))
    fname1 = 'transformation_layer_forward_1';
    fname = strcat(fname1, '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'Learned_Transformation_Matrix_Forward');   
        [rows,columns,layerCount] = size(Learned_Transformation_Matrix_Forward);
    else
        fprintf('Specified file not found in forward path for layer_1\n');
    end          
end

if(strcmpi(path, 'backward'))
    fname1 = 'transformation_layer_backward_1';
    fname = strcat(fname1, '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'Learned_Transformation_Matrix_Backward');    
        [rows,columns,layerCount] = size(Learned_Transformation_Matrix_Backward);
    else
        fprintf('Specified file not found in backward path for layer_1\n');
    end          
end

Test_Img = single(Test_Img_Input);

[m,n] = size(Test_Img);

Transformation_Vector = single(zeros(m,n,layerCount));

Layer_Img_sum = g(1)*Test_Img;
Transformation_Vector(1:m,1:n,1) = Layer_Img_sum;

% coordinates those positions in the image that have non-zero pixel values
% and the intensity or the pixel value.
[coordinates]= getPointsOfInterest(Test_Img); 

for i = 2:layerCount   
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))            
            Transformation_Vector(1:m,1:n,i) = (g(i)*img_transform(coordinates, m, n, Learned_Transformation_Matrix_Forward(:,:,i)));
            Layer_Img_sum = Layer_Img_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            Layer_Img_sum = Layer_Img_sum + (g(i)*img_transform(coordinates, m, n, Learned_Transformation_Matrix_Backward(:,:,i)));
        end        
        
end

Layer_Img = single(Layer_Img_sum); 
end

