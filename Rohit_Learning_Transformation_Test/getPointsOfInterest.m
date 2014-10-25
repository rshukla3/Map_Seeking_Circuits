function [ Coordinate ] = getPointsOfInterest( Img )
%getPoints of interest returns the valueof those coordinates in the image
%that have non zero pixel value.

[m,n] = size(Img);

% Store the coordinates of all those points that have the binary value 1 in
% the image.
index = 1;
for i = 1:m
    for j = 1:n
        if(Img(i,j) ~= 0)
            % i tells the y-coordinate of the image and j tells the
            % x-coordinate.
            Coordinate(index,1) = i;
            Coordinate(index,2) = j;
            Coordinate(index,3) = Img(i,j);
            index = index + 1;
        end
    end
end


end

