function [ transformed_img ] = scale_img(coordinates, m, n, transformation_matrix)
%scale_img outputs the transformed or scaled image
%   scale_img takes the vector coordinates as its input and based on the
%   list of x and y coordinates in this vector it transforms it according
%   to the affine transformation matrix. These transfrmations are later
%   plotted on a blank image of size (m,n).

[Cm, Cn] = size(coordinates);
if(Cn ~=3)
    fprintf('Is there something wrong in generating coordinates  for scale_img functions?\n');
    %exit(0);
end

transformed_img = zeros(m,n);

for i = 1:Cm
    p = [coordinates(i,1) coordinates(i,2) 1] * transformation_matrix;
    transformed_img(fix(p(1)), fix(p(2))) = coordinates(i,3);
end

end

