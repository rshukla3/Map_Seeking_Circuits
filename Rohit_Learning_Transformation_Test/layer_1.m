function [ Layer_Img, Transformation_Vector ] = layer_1( Test_Img_Input,  g, path, fileIndex)
% layer_scaling: In this layer of map seeking circuits we perform image
% scaling.

if(strcmpi(path, 'forward'))
    fname1 = strcat('transformation_layer_forward_',num2str(fileIndex));
    fname = strcat(fname1, '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'Learned_Transformation_Matrix_Forward');   
        [rows,columns,layerCount] = size(Learned_Transformation_Matrix_Forward);
    else
        fprintf('Specified file not found in forward path for layer_1\n');
    end          
end

if(strcmpi(path, 'backward'))
    fname1 = strcat('transformation_layer_backward_',num2str(fileIndex));
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
% fprintf('Declaration just before transformation vector, value of (layerCount+1) is: %d\n', layerCount+1);
    Transformation_Vector = single(zeros(m,n,layerCount+1));
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
            g_T = g(i);
            T = (g_T*img_transform(coordinates, m, n, Learned_Transformation_Matrix_Forward(:,:,i-1)));
            [T_m, T_n] = size(T);
            % fprintf('In the forward path, the size of Transformation_Matrix_Forward is (%d, %d) and Transformation_Vector (%d, %d)\n', T_m, T_n, m, n);
            Transformation_Vector(1:m,1:n,i) = T;
            Layer_Img_sum = Layer_Img_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            if(fileIndex == 4)
                Learned_Transformation_Matrix_Backward(:,:,i-1)
            end
            Layer_Img_sum = Layer_Img_sum + (g(i)*img_transform(coordinates, m, n, Learned_Transformation_Matrix_Backward(:,:,i-1)));            
        end        
        
end

Layer_Img = single(Layer_Img_sum); 
end

