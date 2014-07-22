function [ rotated_img ] = layer_3( input_img, rotationCount, rotationQuantity, g, path )
% layer_2: This is the second layer of the map seeking circuits. This layer
% performs the rotation on input image. Total number of times the rotation
% that is performed on input image is defined by rotationCount and the
% precision of this rotation is defined by rotationQuantity.

rotatedImg_sum = input_img;
for i = 1:rotationCount
    rotationAngle = (i)*rotationQuantity;
    if((g(i) ~= 0)&&(strcmpi(path, 'forward')))
        rotatedImg_sum = rotatedImg_sum + g(i)*imrotate(input_img, rotationAngle, 'nearest', 'crop');
    end
    
    if((g(2*i) ~= 0)&&(strcmpi(path, 'forward')))
        rotatedImg_sum = rotatedImg_sum + g(2*i)*imrotate(input_img, -rotationAngle, 'nearest', 'crop');
    end
    
    if((g(i) ~= 0)&&(strcmpi(path, 'backward')))
        rotatedImg_sum = rotatedImg_sum + g(i)*imrotate(input_img, -rotationAngle, 'nearest', 'crop');
    end
    
    if((g(2*i) ~= 0)&&(strcmpi(path, 'backward')))
        rotatedImg_sum = rotatedImg_sum + g(2*i)*imrotate(input_img, rotationAngle, 'nearest', 'crop');
    end
end

rotated_img = logical(rotatedImg_sum);
end

