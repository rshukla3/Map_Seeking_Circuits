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

% Remember the transforms that we have learned are after we have shifted
% the origin of image from top left corner to the center of the image. This
% transformation is performed in getPointsOfInterest function. Thus after
% we do matrix multiplication, we ensure that we have taken care of
% transformation from center to top-left.

center(1) = round(m/2);
center(2) = round(n/2);

if(mod(m,2) == 0)
    X = center(1)+0.5;
else
    X = center(1);
end

if(mod(n,2) == 0)
    Y = center(2)+0.5;
else
    Y = center(2);
end

for i = 1:Cm
    p = [coordinates(i,1) coordinates(i,2) 1] * transformation_matrix;
    C1 = p(1) + X;
    C2 = p(2) + Y;
    if(C1 > m)
        C1 = m;
    end
    
    if(C2 > n)
        C2 = n;
    end
    
    if(C1 < 1)
        C1 = 1;
    end
    
    if(C2 < 1)
        C2 = 1;
    end
    transformed_img(round(C1), round(C2)) = coordinates(i,3);
end

end

