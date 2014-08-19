function [ q_layer ] = dotproduct( Tf, b )
%dotproduct: Calculate the dot product of the values from first layer.

[m,n,z] = size(Tf);
q_layer = single(zeros(1,z));
for i = 1:z
    Img = Tf(1:m, 1:n, i);
    q_layer(i) = dot(single(Img(:)), single(b(:)));
end

end

