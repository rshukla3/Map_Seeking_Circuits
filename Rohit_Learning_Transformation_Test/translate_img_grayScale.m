function [ output_img ] = translate_img_grayScale( input_img, xTranslate, yTranslate )
%translate_img: Perform the image translation, based on the xTranslate and
% yTranslate values given by the user.

xform = [ 1 0 0;
          0 1 0;
        xTranslate yTranslate 1];
    
% Since image translation is affine transformation, we are defining the tform as affine over here. 

tform_translate = maketform('affine',xform);

[M1 M2] = size(input_img)

translatedImg = (imtransform(input_img, tform_translate, 'XData', [1 (size(input_img,2)+ xform(3,1))], 'YData', [1 (size(input_img,1)+ xform(3,2))]));
figure(18);
imshow(translatedImg);
pause(0.01);
[JM1 JM2] = size(translatedImg)

%% First define the size of the new input image.



if(JM1 < M1)
    if(JM2 < M2)  
                C = imcrop(translatedImg,[1 1 JM2 JM1]);
                new_img(1:JM1, 1:JM2) = 1*imcrop(C);
                new_img(JM1+1:M1, 1:M2) = 0;
                new_img(1:M1, JM2+1:M2) = 0;
        %fprintf('Condition 1\n');
    else
        
                new_img(1:JM1, 1:M2) = 1*imcrop(translatedImg,[1 1 M2 JM1]);
                new_img(JM1+1:M1, 1:M2) = 0;       
        %fprintf('Condition 2\n');
    end
else
    if(JM2 < M2)        
%                 new_img(i, j) = 1*double(translatedImg(i,j)); 
            M1
        C = imcrop(translatedImg,[1 1 JM2 M1]);
        [dd, nn, xx] = size(C)
        new_img(1:M1, 1:JM2) = C(1:M1, 1:JM2);
        new_img(1:M1, JM2+1:M2) = 0;
        %fprintf('Condition 3\n');
    else
        
%                 new_img(i, j) = 1*double(translatedImg(i,j));
        C = imcrop(translatedImg,[1 1 M2 M1]);
        [dd, nn, xx] = size(C)
        new_img(1:M1, 1:M2) = C(1:M1, 1:M2);
        %fprintf('Condition 4\n');
    end
end
% display(translatedImg-new_img);
% fprintf('Hello');
% display(new_img);
figure(19);
imshow(new_img);
pause(0.01);
output_img = new_img;


end

