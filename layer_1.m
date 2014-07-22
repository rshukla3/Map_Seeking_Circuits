function [ xyTranslated_Img ] = layer_1( Test_Img,  translationCount, xTranslateQuantity, yTranslateQuantity, g)
% layer_1: This is the first layer of map seeking circuits where image 
% translation is performed on x and y axes.

xTranslate_sum = Test_Img;

for i = 1:translationCount
    
        xT = (i*xTranslateQuantity);
    
        if(g(i) ~=0)
            xTranslate_sum = xTranslate_sum + (g(i)*translate_img(Test_Img, -xT, 0));
        end
        
        if(g(2*i) ~=0)
            xTranslate_sum = xTranslate_sum + (g(2*i)*translate_img(Test_Img, xT, 0));
        end
end

yTranslate_sum = xTranslate_sum;

superposition_Img_xTranslate = xTranslate_sum;
for i = 1:translationCount
    yT = (i*yTranslateQuantity);
    
    if(g(i) ~=0)
        yTranslate_sum = yTranslate_sum + translate_img(superposition_Img_xTranslate, 0, -yT);
    end
    
    if(g(2*i) ~=0)
        yTranslate_sum = yTranslate_sum + translate_img(superposition_Img_xTranslate, 0, yT);
    end
end

xyTranslated_Img = logical(yTranslate_sum); 
end

