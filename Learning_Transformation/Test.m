clc;
clear all;
close all;
[Test_Img] = imagePreProcessing('pepper_2.jpg');
[I] = imagePreProcessing('sailboat_2.jpg');

I_new = I + Test_Img;
Test_Img = single(logical(imrotate(Test_Img, 0, 'bilinear', 'crop')));
dotProductValue = dotproduct(I_new,Test_Img);

fprintf('The value of dotproduct is : %d\n', dotProductValue);



figure(1);
imshow(Test_Img);

figure(2);
imshow(I);

figure(3);
imshow(I_new);
