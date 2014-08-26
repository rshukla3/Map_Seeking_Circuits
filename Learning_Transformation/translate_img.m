function [ output_img ] = translate_img( input_img, xTranslate, yTranslate )
%translate_img: Perform the image translation, based on the xTranslate and
% yTranslate values given by the user.

xform = [ 1 0 0;
          0 1 0;
        xTranslate yTranslate 1];
    
% Since image translation is affine transformation, we are defining the tform as affine over here. 

tform_translate = maketform('affine',xform);

[M1 M2] = size(input_img);

translatedImg = single(imtransform(input_img, tform_translate, 'XData', [1 (size(input_img,2)+ xform(3,1))], 'YData', [1 (size(input_img,1)+ xform(3,2))]));

[JM1 JM2] = size(translatedImg);

%% First define the size of the new input image.

new_img_1 = zeros(M1, M2);

% Since zeros function defines the matrix for double datatype, we will
% change the datatype of this matrix to uint8 as we will be mostly dealing
% with grayscale images.
new_img = single(new_img_1);

if(JM1 < M1)
    if(JM2 < M2)        
        new_img(1:JM1, 1:JM2) = translatedImg;
        fprintf('Condition 1\n');
    else
        new_img(1:JM1, 1:M2) = translatedImg(1:JM1, 1:M2);
        fprintf('Condition 2\n');
    end
else
    if(JM2 < M2)
        new_img(1:M1, 1:JM2) = translatedImg(1:M1, 1:JM2);
        fprintf('Condition 3\n');
    else
        new_img(1:M1, 1:M2) = translatedImg(1:M1, 1:M2);
        fprintf('Condition 4\n');
    end
end


output_img = new_img;


end

