clc;
clear all;
close all;
[Test_Img] = imagePreProcessing('pepper_2.jpg');
[I] = imagePreProcessing('sailboat_2.jpg');

I_new = I + Test_Img;

M_Img(:,:,1) = Test_Img;
M_Img(:,:,2) = I;

I_Rotate_tmp = single(logical(imrotate(Test_Img, 45, 'nearest', 'crop')));

I_Rotate_1 = single(logical(imrotate(I_Rotate_tmp, -15, 'nearest', 'crop')));
I_Rotate_2 = single(logical(imrotate(I_Rotate_tmp, -30, 'nearest', 'crop')));
I_Rotate_3 = single(logical(imrotate(I_Rotate_tmp, -45, 'nearest', 'crop')));

I_Rotate = I_Rotate_1 + I_Rotate_2 + I_Rotate_3;

I_Translate_1 = translate_img(I_Rotate, 0, -20);
I_Translate_2 = translate_img(I_Rotate, 0, 20);
I_Translate_3 = translate_img(I_Rotate, 0, 0);
I_Translate_4 = translate_img(I_Rotate, 0, -40);
I_Translate_5 = translate_img(I_Rotate, 0, 40);

I_Translate_6 = translate_img(I_Rotate, -20, 0);
I_Translate_7 = translate_img(I_Rotate, 20, 0);
I_Translate_8 = translate_img(I_Rotate, -40, 0);
I_Translate_9 = translate_img(I_Rotate, 40, 0);
I_Translate_10 = translate_img(I_Rotate, 0, 0);

I_Translate = I_Translate_1 + I_Translate_2 + I_Translate_3 + I_Translate_4 + I_Translate_5 + I_Translate_6 + I_Translate_7 + I_Translate_8 + I_Translate_9 + I_Translate_10;

%I_Sum = sum(sum(I_Rotate));
%fprintf('The value of I_Sum is : %d and input image is: %d\n', I_Sum,sum(sum(Test_Img)));


dotProductValue = dotproduct(M_Img,I_Translate);
fprintf('The value of dotproduct is : %d\n', dotProductValue);



figure(1);
imshow(Test_Img);

figure(2);
imshow(I_Rotate);

figure(3);
imshow(I_new);
