function assignNewIndependentLayer(Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward, layerCount)
%assignNewIndependentLayer: Assign a new independent function layer that
%saves the newly learned affine transformation.
%   Detailed explanation goes here

fname1 = strcat('transformation_layer_forward_', num2str(layerCount-1));
fname = strcat(fname1, '.mat');

if exist(fname, 'file') ~= 2
    save(fname, Learned_Transformation_Matrix_Forward);    
end

fname2 = strcat('transformation_layer_backward_', num2str(layerCount-1));
fname = strcat(fname2, '.mat');

if exist(fname, 'file') ~= 2
    save(fname, Learned_Transformation_Matrix_Backward);    
end
end

