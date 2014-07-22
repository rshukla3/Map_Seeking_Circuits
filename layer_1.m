function [ xTranslated_Img ] = layer_1( Test_Img,  translationCount, xTranslateQuantity, g, path)
% layer_1: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

xTranslate_sum = Test_Img;

for i = 1:translationCount
    
        xT = (i*xTranslateQuantity);
    
        if((g(i) ~=0)&&(strcmpi(path, 'forward')))
            xTranslate_sum = xTranslate_sum + (g(i)*translate_img(Test_Img, xT, 0));
        end
        
        if((g(2*i) ~=0)&&(strcmpi(path, 'forward')))
            xTranslate_sum = xTranslate_sum + (g(2*i)*translate_img(Test_Img, -xT, 0));
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

