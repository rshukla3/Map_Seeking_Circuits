function [  ] = updateIndependentLayer(Learned_Transformation_Matrix_Forward, Learned_Transformation_Matrix_Backward, appendedToLayer)
%updateIndependentLayer: update the information of already learned
%function.

if(appendedToLayer == 1)
    if exist('scaling_transformation_forward.mat', 'file') == 2
        load('scaling_transformation_forward.mat', 'scaling_transformation_forward'); 
        [m,n,Values] = size(scaling_transformation_forward);
        scaling_transformation_forward(:,:,Values+1) = Learned_Transformation_Matrix_Forward;
        save('scaling_transformation_forward.mat', scaling_transformation_forward);
    else
        fprintf('The selected scaling_transformation_forward.mat file does not exist\n');    
    end
    
    if exist('scaling_transformation_backward.mat', 'file') == 2
        load('scaling_transformation_backward.mat', 'scaling_transformation_backward');  
        [m,n,Values] = size(scaling_transformation_backward);
        scaling_transformation_backward(:,:,Values+1) = Learned_Transformation_Matrix_Backward;
        save('scaling_transformation_backward.mat', scaling_transformation_backward);
    else
        fprintf('The selected scaling_transformation_backward.mat file does not exist\n');    
    end
else
    fname1 = strcat('transformation_layer_forward_', num2str(appendedToLayer));
    fname = strcat(fname1, '.mat');
    if exist(fname, 'file') == 2
        load(fname, 'M');    
        [m,n,Values] = size(M);
        M(:,:,Values+1) = Learned_Transformation_Matrix_Forward;
        save(fname, M);
    else
        fprintf('The selected scaling_transformation_forward.mat file does not exist\n');    
    end

    fname1 = strcat('transformation_layer_backward_', num2str(appendedToLayer));
    fname = strcat(fname1, '.mat');
    
    if exist(fname, 'file') == 2
        load(fname, 'M');    
        [m,n,Values] = size(M);
        M(:,:,Values+1) = Learned_Transformation_Matrix_Backward;
        save(fname, M);   
    else
        fprintf('The selected scaling_transformation_backward.mat file does not exist\n');    
    end
end

end

