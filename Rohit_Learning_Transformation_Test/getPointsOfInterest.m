function [ Coordinate ] = getPointsOfInterest( Img )
%getPoints of interest returns the valueof those coordinates in the image
%that have non zero pixel value.

[m,n] = size(Img);

% We are moving the origin to the center of the image. Right now it is
% fixed at top left corner. To take care of this origin translation, we
% calculate the size of the image and then divide it by 2.

center = round(size(Img)/2);

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


% Store the coordinates of all those points that have the binary value 1 in
% the image.
index = 1;
for i = 1:m
    for j = 1:n
        if(Img(i,j) ~= 0)
            % i tells the y-coordinate of the image and j tells the
            % x-coordinate.
            Coordinate(index,1) = i-X;
            Coordinate(index,2) = j-Y;
            Coordinate(index,3) = Img(i,j);
            index = index + 1;
        end
    end
end


end

