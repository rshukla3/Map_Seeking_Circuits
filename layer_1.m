function [ xTranslated_Img, Transformation_Vector_Zero ] = layer_1( Test_Img,  translationCount, xTranslateQuantity, g, path)
% layer_1: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

xTranslate_sum = Test_Img;

[m,n] = size(Test_Img);

Transformation_Vector = logical(zeros(m,n,2*translationCount));

% Value of f0 is 0. So the vector T(f0) should be a zero vector.
Transformation_Vector_Zero = Transformation_Vector;

for i = 1:translationCount
    
        xT = (i*xTranslateQuantity);
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))            
            Transformation_Vector(1:m,1:n,i) = (g(i)*translate_img(Test_Img, xT, 0));
            xTranslate_sum = xTranslate_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        if((g(2*i) ~=0)&&(strcmpi(path, 'forward')))
             Transformation_Vector(1:m,1:n,2*i) = (g(2*i)*translate_img(Test_Img, -xT, 0));
             xTranslate_sum = xTranslate_sum + Transformation_Vector(1:m,1:n,2*i);
        end
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            xTranslate_sum = xTranslate_sum + (g(i)*translate_img(Test_Img, -xT, 0));
        end
        
        if((g(2*i) ~=0)&&(strcmpi(path, 'backward')))
            xTranslate_sum = xTranslate_sum + (g(2*i)*translate_img(Test_Img, xT, 0));
        end
end

xTranslated_Img = logical(xTranslate_sum); 
end

