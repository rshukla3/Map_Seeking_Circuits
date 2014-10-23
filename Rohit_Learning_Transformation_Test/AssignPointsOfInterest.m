function [ new_img ] = AssignPointsOfInterest( Memory_Img )
%AssignPointsOfInterest This function assigns points of interest to input
%image
%   Mark areas of interest (or regions of intest in the input image). 

NumberOfArbitraryPoints = 70; % Let the user decide how many number of arbitrary 
                              % points he/she wants.

%% Assign x and y coordinates that belong to areas of interest.

[m,n] = size(Memory_Img);

% Store the coordinates of all those points that have the binary value 1 in
% the image.
index = 1;
for i = 1:m
    for j = 1:n
        if(Memory_Img(i,j) == 1)
            % i tells the y-coordinate of the image and j tells the
            % x-coordinate.
            Coordinate(index,1) = i;
            Coordinate(index,2) = j;
            index = index + 1;
        end
    end
end

% Generate random integer numbers, to get x and y coordinates of image with
% binary value 1, randomly.
generatedRandomIndex = zeros(1,index-1);
flag = 0;
for i = 1:NumberOfArbitraryPoints
    while(flag == 0)
        randomIndex = randi([1 index-1], 1, 1);
        % If the generated random number already exists then continue in
        % while loop, else exit loop.
        if(find(generatedRandomIndex == randomIndex))
            flag = 0;
        else
            flag = 1;
            generatedRandomIndex(i) = randomIndex;
        end
    end
    flag = 0;
    y(i) = Coordinate(randomIndex, 1);
    x(i) = Coordinate(randomIndex, 2);
end


% Based on these generated random coordinates for the image, draw the image
% with points of interest.
% This is done using impoint and createMask function for ROI.
new_img = zeros(size(Memory_Img));
h_im = imshow(Memory_Img);
e = impoint(gca, x(1), y(1));
BW = createMask(e,h_im);
new_img = new_img + (BW.*255);
for i = 2:NumberOfArbitraryPoints
    setPosition(e, x(i), y(i));
    BW = createMask(e,h_im);
    if(new_img(x(i), y(i)) == 0)
        new_img = new_img + BW.*(255-i+1);
    end
end
figure(3);
imshow(new_img);

end

