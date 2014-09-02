clc;
clear all;
close all;
[Test_Img] = imagePreProcessing();
I = imrotate(Test_Img, 180, 'nearest', 'crop');

dotProductValue = dotproduct(I,Test_Img);

fprintf('The value of dotproduct is : %d\n', dotProductValue);
figure(1);
imshow(Test_Img);

figure(2);
imshow(I);