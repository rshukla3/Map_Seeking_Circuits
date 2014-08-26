function [ yTranslated_Img, Transformation_Vector ] = layer_2( Test_Img,  translationCount, yTranslateQuantity, g, path)
% layer_2: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

[m,n] = size(Test_Img);
Transformation_Vector = single(zeros(m,n,2*translationCount+1));

yTranslate_sum = g(translationCount+1)*Test_Img;
Transformation_Vector(1:m,1:n,translationCount+1) = yTranslate_sum;

for i = 1:translationCount
    yT = (i*yTranslateQuantity);
    
    if((g(i) ~=0)&&(strcmpi(path, 'forward')))
        Transformation_Vector(1:m,1:n,i) = (g(i)*translate_img(Test_Img, 0, yT));
        yTranslate_sum = yTranslate_sum + Transformation_Vector(1:m,1:n,i);
    end
    
    if((g(i+translationCount+1) ~=0)&&(strcmpi(path, 'forward')))
        Transformation_Vector(1:m,1:n,i+translationCount+1) = (g(i+translationCount+1)*translate_img(Test_Img, 0, -yT));
        yTranslate_sum = yTranslate_sum + Transformation_Vector(1:m,1:n,i+translationCount+1);
    end
    
    if((g(i) ~=0)&&(strcmpi(path, 'backward')))
        yTranslate_sum = yTranslate_sum + (g(i)*translate_img(Test_Img, 0, -yT));
    end
    
    if((g(i+translationCount+1) ~=0)&&(strcmpi(path, 'backward')))
        yTranslate_sum = yTranslate_sum + (g(i+translationCount+1)*translate_img(Test_Img, 0, yT));
    end
end

yTranslated_Img = single(yTranslate_sum); 
end

