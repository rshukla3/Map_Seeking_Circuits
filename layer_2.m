function [ yTranslated_Img, Transformation_Vector ] = layer_2( Test_Img,  translationCount, yTranslateQuantity, g, path)
% layer_2: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

yTranslate_sum = Test_Img;

[m,n] = size(Test_Img);
Transformation_Vector = logical(zeros(m,n,2*translationCount));

for i = 1:translationCount
    yT = (i*yTranslateQuantity);
    
    if((g(i) ~=0)&&(strcmpi(path, 'forward')))
        Transformation_Vector(1:m,1:n,i) = (g(i)*translate_img(Test_Img, 0, yT));
        yTranslate_sum = yTranslate_sum + Transformation_Vector(1:m,1:n,i);
    end
    
    if((g(2*i) ~=0)&&(strcmpi(path, 'forward')))
        Transformation_Vector(1:m,1:n,2*i) = (g(2*i)*translate_img(Test_Img, 0, -yT));
        yTranslate_sum = yTranslate_sum + Transformation_Vector(1:m,1:n,2*i);
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

