function [ b_memoryLayer, mem_img_output ] = layer_memory( g_mem, Memory_Img, memory_units )
%Get the images stored in the memory from the files tha have been written.


fname = strcat('mem_img', '.mat');
if exist(fname, 'file') == 2
    load(fname, 'mem_img');   
    [rows,columns,memory_units] = size(mem_img);
else
    fprintf('Specified file not found in forward path for layer_1\n');
end          


% g_mem is the g value for competing memory layer values and Memory_Img has
% all the memory images.

% Get the dimensions of the first Memory_Img and use it to initialize the
% dimension of superimposed images.

[m,n] = size(mem_img(:,:,1));

superposition = single(zeros(m,n));

for i=1:memory_units
    T = g_mem(i)*(mem_img(:,:,i));
    mem_img_output(1:m,1:n,i) = T;
    superposition = superposition + T;
end

b_memoryLayer = superposition;
end

