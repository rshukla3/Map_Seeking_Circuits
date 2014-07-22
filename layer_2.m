function [ yTranslated_Img ] = layer_2( Test_Img,  translationCount, yTranslateQuantity, g, path)
% layer_2: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

yTranslate_sum = Test_Img;

for i = 1:translationCount
    yT = (i*yTranslateQuantity);
    
    if((g(i) ~=0)&&(strcmpi(path, 'forward')))
        yTranslate_sum = yTranslate_sum + translate_img(Test_Img, 0, yT);
    end
    
    if((g(2*i) ~=0)&&(strcmpi(path, 'forward')))
        yTranslate_sum = yTranslate_sum + translate_img(Test_Img, 0, -yT);
    end
    
    if((g(i) ~=0)&&(strcmpi(path, 'backward')))
        yTranslate_sum = yTranslate_sum + translate_img(Test_Img, 0, -yT);
    end
    
    if((g(2*i) ~=0)&&(strcmpi(path, 'backward')))
        yTranslate_sum = yTranslate_sum + translate_img(Test_Img, 0, yT);
    end
end

yTranslated_Img = logical(yTranslate_sum); 
end

