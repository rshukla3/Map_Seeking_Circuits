function [ output_img ] = scaleImg( input_img, xScale, yScale )
%Performs scaling on the image in such a way that dimensions of original
%image does not change.

if(xScale == 0)
    xScale = 1;
end

if(yScale == 0)
    yScale = 1;
end

[m,n] = size(input_img);

resized_img = imresize(input_img, 'Scale', [xScale yScale]);

[rm, rn] = size(resized_img);

new_img = single(zeros(m,n));

if(rm < m)
    padXAxis = (m-rm)/2;
    if(rn < n)
        padYAxis = (n-rn)/2;
        new_img(1:m, 1:n) = padarray(resized_img, [padXAxis padYAxis]);
    else
        new_img_padded(1:m, 1:rn) = padarray(resized_img(:,1:rn), [padXAxis 0]);
        new_img(1:m, 1:n) = new_img_padded(1:m, rn/2-n/2+1:rn/2+n/2);
    end
else
    if(rn < n)
        padYAxis = (n-rn)/2;
        new_img_padded(1:rm, 1:n) = padarray(resized_img(1:rm,:), [0 padYAxis]);
        new_img = new_img_padded(rm/2-m/2+1:rm/2+m/2, 1:n);
    else
        new_img_padded(1:rm, 1:rn) = padarray(resized_img(1:rm,1:rn), [0 0]);        
        new_img = new_img_padded( fix(rm/2) - fix(m/2)+1:fix(rm/2) + fix(m/2), fix(rn/2) - fix(n/2)+1:fix(rn/2) + fix(n/2) );
    end
end

output_img = new_img;

end

