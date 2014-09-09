clc;
clear all;
close all;
[Test_Img] = imagePreProcessing();
I = translate_img(Test_Img, 20, 0);

dotProductValue = dotproduct(I,Test_Img);

fprintf('The value of dotproduct is : %d\n', dotProductValue);

I_new = I + Test_Img;

figure(1);
imshow(Test_Img);

figure(2);
imshow(I);

figure(3);
imshow(I_new);
