function [ Layer_Img, Transformation_Vector ] = layer_1( Test_Img_Input,  g, path)
% layer_scaling: In this layer of map seeking circuits we perform image
% scaling.

if(strcmpi(path, 'forward'))
    fname1 = 'transformation_layer_forward_2';
    fname = strcat(fname1, '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'Learned_Transformation_Matrix_Forward');   
        [rows,columns,layerCount] = size(Learned_Transformation_Matrix_Forward);
    else
        fprintf('Specified file not found in forward path for layer_1\n');
    end          
end

if(strcmpi(path, 'backward'))
    fname1 = 'transformation_layer_backward_2';
    fname = strcat(fname1, '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'Learned_Transformation_Matrix_Backward');    
        [rows,columns,layerCount] = size(Learned_Transformation_Matrix_Backward);
        fprintf('In the backward path the value of rows: %d columns: %d layerCount: %d\n',rows,columns,layerCount);
    else
        fprintf('Specified file not found in backward path for layer_1\n');
    end          
end

Test_Img = single(Test_Img_Input);

[m,n] = size(Test_Img);
%if(strcmpi(path, 'forward'))
    Transformation_Vector = single(zeros(m,n,layerCount));
%end

Layer_Img_sum = g(1)*Test_Img;

%if(strcmpi(path, 'forward'))
    Transformation_Vector(1:m,1:n,1) = Layer_Img_sum;
%end

% coordinates those positions in the image that have non-zero pixel values
% and the intensity or the pixel value.
[coordinates]= getPointsOfInterest(Test_Img); 

for i = 2:layerCount+1   
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))            
            Transformation_Vector(1:m,1:n,i) = (g(i)*img_transform(coordinates, m, n, Learned_Transformation_Matrix_Forward(:,:,i-1)));
            Layer_Img_sum = Layer_Img_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            Layer_Img_sum = Layer_Img_sum + (g(i)*img_transform(coordinates, m, n, Learned_Transformation_Matrix_Backward(:,:,i-1)));
        end        
        
end

Layer_Img = single(Layer_Img_sum); 
end

