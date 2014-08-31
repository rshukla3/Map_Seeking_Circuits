clc;
clear all;
close all;
[Test_Img] = imagePreProcessing();
I = imrotate(Test_Img, 30, 'nearest', 'crop');
figure(1);
imshow(Test_Img);

figure(2);
imshow(I);