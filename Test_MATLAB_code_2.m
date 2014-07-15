clear all;
close all;
clc;

%% Read the image that is to be stored in memory.

Read_Memory_Img = imread('Memory_Img.jpg');

%% Create test image.

% First step of the map seeking circuit would be to create a test image.

% Here we will be doing changes in the memory image itself and later
% performing the MSC layer functions on it.

[RM1, RM2] = size(Read_Memory_Img);
Memory_Img = imresize(Read_Memory_Img, [150 150]);
[M1, M2] = size(Memory_Img);

% Rotate the memory image by 45 degrees in CW direction.
Rotated_Image = imrotate(Memory_Img, 45);

% Truncate the outer sections of the rotated image so that the size of the
% rotated image is the same as memory image.

% Step 1. Get the size of the image so that we can get its center.
[Im4, In4] = size(Rotated_Image);
x = round(Im4/2);
y = round(In4/2);

m = fix(M1/2);
n = fix(M2/2);

r1 = x-m+1;
r2 = x+m+1;

c1 = y-n;
c2 = y+(n);

Truncated_Rotate_Img = Rotated_Image(r1:r2, c1:c2);

TR_Img = Truncated_Rotate_Img;

% The next step would be to translate the image for further tests.

%Translate_Truncate_Rotate_Img = imtranslate(Truncated_Rotate_Img, [5, 5], 'FillValues', 0);
%Translate_Truncate_Rotate_Img = imtranslate(Memory_Img, [5.4, 4.5], 'FillValues', 0);

%Changing the Translate_Truncate_Rotate_Img name to TTR_Img.

%TTR_Img = Translate_Truncate_Rotate_Img;

figure(1);
imshow(Memory_Img);

figure(2);
imshow(TR_Img);
