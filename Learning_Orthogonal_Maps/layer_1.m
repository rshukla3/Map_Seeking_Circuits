function [ xTranslated_Img, Transformation_Vector ] = layer_1( Test_Img_Input,  translationCount, xTranslateQuantity, g, path)
% layer_1: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

Test_Img = single(Test_Img_Input);

% fprintf('Test image after single conversion\n');
% display(Test_Img);

[m,n] = size(Test_Img);

Transformation_Vector = single(zeros(m,n,2*translationCount+1));

% Value of f0 is 0. So the vector T(f0) should be a zero vector.
%Transformation_Vector_Zero = Transformation_Vector;

xTranslate_sum = g(translationCount+1)*Test_Img;
Transformation_Vector(1:m,1:n,translationCount+1) = xTranslate_sum;

for i = 1:translationCount
    
        xT = (i*xTranslateQuantity);
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))            
            Transformation_Vector(1:m,1:n,i) = (g(i)*translate_img(Test_Img, xT, 0));
            xTranslate_sum = xTranslate_sum + Transformation_Vector(1:m,1:n,i);
        end
        
        if((g(i+translationCount+1) ~=0)&&(strcmpi(path, 'forward')))
             Transformation_Vector(1:m,1:n,(i+translationCount+1)) = (g(i+translationCount+1)*translate_img(Test_Img, -xT, 0));
             xTranslate_sum = xTranslate_sum + Transformation_Vector(1:m,1:n,(i+translationCount+1));
        end
        
        if((g(i) ~=0)&&(strcmpi(path, 'backward')))
            xTranslate_sum = xTranslate_sum + (g(i)*translate_img(Test_Img, -xT, 0));
        end
        
        if((g(i+translationCount+1) ~=0)&&(strcmpi(path, 'backward')))
            xTranslate_sum = xTranslate_sum + (g(i+translationCount+1)*translate_img(Test_Img, xT, 0));
        end
end

xTranslated_Img = single(xTranslate_sum); 
end

