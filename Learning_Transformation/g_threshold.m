function [ g_layer_output ] = g_threshold( g_layer, gThresh )
%Calculates the next values of g_layer based on the current g_layer values
%and gThresh set by the user.
[m,n] = size(g_layer);

maxIndex = max([m n]);

g_layer_output = single(zeros(m,n));
for i = 1:maxIndex
    if(g_layer(i) >= gThresh)
        g_layer_output(i) = g_layer(i);
    end
end
end

