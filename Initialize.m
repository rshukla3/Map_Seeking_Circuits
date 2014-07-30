function [ Memory_Img, Test_Img ] = Initialize( memory_units )
%Initialize the memory unit of MSC. Read the images, and convert them to
%grayscale images.

%% Read the image that is to be stored in memory.

Read_Memory_Img_1 = imread('Memory_Img_small_Rectangle.jpg');
Read_Memory_Img_2 = imread('Memory_Img_small_Circle.jpg');

[FRm FRn] = size(Read_Memory_Img_1);

%% Read the test image that is to be recognized against the image stored in memory.

Read_Test_Img = imread('Test_Img_Rotated_Rectangle.jpg');

%% Convert he two images to grayscale.
memory_units
FRm
FRn
Memory_Img_gray = zeros(FRm,FRn, memory_units);
Memory_Img_gray(1:FRm,1:FRn,1) = rgb2gray(Read_Memory_Img_1);
Memory_Img_gray(1:FRm,1:FRn,2) = rgb2gray(Read_Memory_Img_2);

Test_Img_gray = rgb2gray(Read_Test_Img);

Level_Memory_Img = zeros(memory_units);
for i=1:memory_units
    Level_Memory_Img(i) = graythresh(Memory_Img_gray(:,:,i));
end

Level_Test_Img = graythresh(Test_Img_gray);

Memory_Img = logical(zeros(FRm, FRn, memory_units));

for i = 1:memory_units
    Memory_Img(:,:,i) = im2bw(Memory_Img_gray(:,:,i), Level_Memory_Img(i));
end

Test_Img = im2bw(Test_Img_gray, Level_Test_Img);

%Test_Img_Rotated = imrotate(Memory_Img, 45, 'nearest', 'crop');

%Test_Img = translate_img(Test_Img_Rotated, -300, -300);

clear Read_Memory_Img;
clear Read_Memory_Img_1;
clear Read_Test_Img;

clear Memory_Img_gray;
clear Memory_Img_gray_1;
clear Test_Img_gray;


end

