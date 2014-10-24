clc;
close all;
clear all;

% 2. Read the already stored images from tif image file.
fname = 'Memory_Images.tif';
if exist(fname, 'file') == 2
    info = imfinfo(fname);
    memory_units = numel(info);
    for k = 1:memory_units
        Memory_Img(:,:,k) = single(logical(imread(fname, k, 'Info', info)));
    end
else
    Memory_Img = [];
end


%% Read the test image and the image that is to be stored in memory.

% Read the test image and the image that is to be stored in memory and
% later do preprocessing on them.

[Preprocessed_Img] = imagePreProcessing('pepper_2.jpg');

[Img_PointsOfInterest, x , y] = AssignPointsOfInterest(Preprocessed_Img);
%Test_Img = single(imrotate(Test_Img, 180, 'nearest', 'crop'));
Test_Img = translate_img(Img_PointsOfInterest, 180, 0);
%% Transform the image matrix to single dimension.
% Transform the image matrix to single dimension with only the value (or 
% coordinates of the image) in it.

[m,n,memory_count] = size(Memory_Img);

Memory_Img_tmp = Memory_Img(:,:,1);


index = 1;
for i = 1:m
    for j = 1:n
        if(Img_PointsOfInterest(i,j) ~= 0)
            Coordinate(index,1) = i;
            Coordinate(index,2) = j;
            Coordinate(index,3) = 1;
            index = index + 1;
        end
    end
end

[tm,tn] = size(Test_Img);

index = 1;
for i = 1:1:tm
    for j = 1:1:tn
        if(Test_Img(i,j) ~= 0)
            Coordinate_Test(index,1) = i;
            Coordinate_Test(index,2) = j;
            Coordinate_Test(index,3) = 1;
            index = index + 1;
        end
    end
end
figure(1);
imshow(Img_PointsOfInterest);

figure(2);
imshow(Test_Img);

M = Coordinate\Coordinate_Test;

[m,n] = size(M);

for i = 1:m
    for j = 1:n
        if(abs(M(i,j)) < 0.001)
            M(i,j) = 0;
        end
        if(abs(M(i,j)-1) < 0.001)
            M(i,j) = 1;
        end
    end
end


[Test_Img_2] = imagePreProcessing('sailboat_2.jpg');
figure(3);
imshow(Test_Img_2);
[tm,tn] = size(Test_Img_2);

index = 1;

New_Img = zeros(tm,tn);
for i = 1:tm
    for j = 1:tn
        if(Test_Img_2(i,j) ~= 0)
            P = [i j 1]*M;
            Coordinate_Test(index,1) = P(1);
            Coordinate_Test(index,2) = P(2);
            Coordinate_Test(index,3) = P(3);
            New_Img(fix(P(1)), fix(P(2))) = 1;
            index = index + 1;
        end
    end
end

fprintf('The value of M is:\n');
disp(M);

figure(4);
imshow(New_Img);