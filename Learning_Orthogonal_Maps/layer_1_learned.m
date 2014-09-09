function [ Transformation_Matrix, memory_units, learned ] = layer_1_learned( Test_Img_Input,  Memory_Img)
% layer_1: This is the first layer of map seeking circuits where image 
% translations are being learned.
    memory_units = 0;
    learned = 1;
    fname = 'Transformation_Matrix.mat';
    if exist(fname, 'file') == 2
        load('Transformation_Matrix.mat');
        [m,n,memory_units] = size(Transformation_Matrix);
    else
        Transformation_Matrix = [];
    end
    memory_units = memory_units + 1;
    
    Transformation_Matrix(:,:,memory_units) = single((Test_Img_Input)-(Memory_Img));   
    
    save('Transformation_Matrix.mat', 'Transformation_Matrix');
end

