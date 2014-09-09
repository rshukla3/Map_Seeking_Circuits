function [ Memory_Img, Test_Img ] = imagePreProcessing( )
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Read_Memory_Img = imread('alarm_clock_test.png');

%Read_Memory_Img = scaleImg(Read_Memory_Img, 100, 100);

Read_Test_Img = imread('alarm_clock_double_bell.jpg');

%Read_Test_Img = scaleImg(Read_Test_Img, 100, 100);
Memory_Img_gray = Read_Memory_Img;
%Memory_Img_gray = rgb2gray(Read_Memory_Img);
Test_Img_gray = rgb2gray(Read_Test_Img);
%Test_Img_gray = Read_Test_Img;

%h = fspecial('gaussian', size(Memory_Img_gray), 1.5);
%Memory_Img_gray = imfilter(Memory_Img_gray, h);

%Memory_Img_gray(Memory_Img_gray == 255) = 0;


%[Memory_Img_Canny, Thresh] = edge(Memory_Img_BW, 'canny');
%[Test_Img_Canny, Thresh2] = edge(Test_Img_BW, 'canny');

[~, Thresh] = edge(Memory_Img_gray, 'prewitt');
Memory_Img_BW = edge(Memory_Img_gray, 'prewitt', Thresh*0.5);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

Memory_Img_dilate = imdilate(Memory_Img_BW, [se90 se0]);

Memory_Img_Fill = imfill(Memory_Img_dilate, 'holes');

%Memory_Img_Border = imclearborder(Memory_Img_Fill, 4);

seD = strel('diamond',1);
Memory_Img_Final = imerode(Memory_Img_Fill,seD);
Memory_Img_Erode = imerode(Memory_Img_Final,seD);
%Memory_Img_Erode = imclearborder(Memory_Img_Erode, 6);
BWoutline = edge(Memory_Img_Erode);
Memory_Img = logical(zeros(256, 256));
Memory_Img(BWoutline) = 1;

%h = fspecial('gaussian', size(Memory_Img), 0.08);
%Memory_Img = imfilter(Memory_Img, h);

%D = bwdist(Test_Img_Canny);

%h = fspecial('gaussian', size(Test_Img_Canny), 0.1);

% Test_Img = imfilter(Test_Img_Canny, h);

[~, Thresh] = edge(Test_Img_gray, 'prewitt');
Test_Img_BW = edge(Test_Img_gray, 'prewitt', Thresh*0.5);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

Test_Img_dilate = imdilate(Test_Img_BW, [se90 se0]);

Test_Img_Fill = imfill(Test_Img_dilate, 'holes');

%Test_Img_Border = imclearborder(Test_Img_Fill, 4);

seD = strel('diamond',1);
Test_Img_Final = imerode(Test_Img_Fill,seD);
Test_Img_Erode = imerode(Test_Img_Final,seD);

BWoutline = edge(Test_Img_Erode);
Test_Img = logical(zeros(256, 256));
Test_Img(BWoutline) = 1;

%[m,n] = size(Test_Img);
%fprintf('The size of test image is %d-by-%d\n', m, n);
% Fill closed objects:
%Test_Img_Holes = imfill(Test_Img_Canny , 'holes');
% Get rid of objects less than 500 pixels:
%Test_Img = bwareaopen(Test_Img_Holes, 0);
%s_Img(311:410,:)=0;
figure(1);
imshow(Memory_Img_Erode);

figure(2);
imshow(Test_Img);

%figure(3);
%imshow(blurredImage);
end

