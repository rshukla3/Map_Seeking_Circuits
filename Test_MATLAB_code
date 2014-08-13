clear all;
close all;
clc;
Test_Img1 = imread('Test_Img.jpg');
Memory_Img = imread('Memory_Img.jpg');

[M1, M2] = size(Memory_Img);

Test_Img = imresize(Test_Img1, [M1 M2]);

Img3 = imrotate(Memory_Img, 45);
Img4 = imresize(Img3, [M1 M2]);
[Im4, In4] = size(Img4);
x = round(Im4/2);
y = round(In4/2);

m = fix(M1/2);
n = fix(M2/2);

r1 = x-m+1;
r2 = x+m;

c1 = y-n;
c2 = y+(n);
Img4 = Img4(r1:r2, c1:c2);

figure(1);
imshow(Test_Img);

figure(2);
imshow(Memory_Img);

figure(3);
imshow(Img4);

[T1, T2] = size(Test_Img);
