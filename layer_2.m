function [ rotated_img ] = layer_2( input_img, rotationCount, rotationQuantity )
% layer_2: This is the second layer of the map seeking circuits. This layer
% performs the rotation on input image. Total number of times the rotation
% that is performed on input image is defined by rotationCount and the
% precision of this rotation is defined by rotationQuantity.

rotated_img = imrotate(input_img, rotationQuantity, 'nearest', 'crop');
end

