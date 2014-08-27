function [ b_memoryLayer ] = layer_memory( g_mem, Memory_Img, memory_units )
%Calculates the superposition of images on the backward path.

% g_mem is the g value for competing memory layer values and Memory_Img has
% all the memory images.

% Get the dimensions of the first Memory_Img and use it to initialize the
% dimension of superimposed images.

[m,n] = size(Memory_Img(:,:,1));

superposition = single(zeros(m,n));

for i=1:memory_units
    superposition = superposition + g_mem(i)*single(Memory_Img(:,:,i));
end

b_memoryLayer = superposition;
end

