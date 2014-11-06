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
%[output] = FeatureExtractors(Preprocessed_Img);
% Test_Img = single(imrotate(Img_PointsOfInterest, -45, 'nearest', 'crop'));
% Test_Img = translate_img(Img_PointsOfInterest, 180, 0);
Test_Img = single(scaleImg(Img_PointsOfInterest, 0.6, 0.6));
%% Transform the image matrix to single dimension.
% Transform the image matrix to single dimension with only the value (or 
% coordinates of the image) in it.

[m,n,memory_count] = size(Memory_Img);

Memory_Img_tmp = Memory_Img(:,:,1);

center = round(size(Img_PointsOfInterest)/2);
index = 1;

X = center(1)+0.5;
Y = center(2)+0.5;
for i = 1:m
    for j = 1:n
        if(Img_PointsOfInterest(i,j) ~= 0)
            Coordinate(index,1) = i-X;
            Coordinate(index,2) = j-Y;
            Coordinate(index,3) = Img_PointsOfInterest(i,j);
            index = index + 1;
        end
    end
end
index_prev = index;
[tm,tn] = size(Test_Img);
pixelVal = max(max(Test_Img));
index = 1;
for i = 1:1:tm
    for j = 1:1:tn
        if((Test_Img(i,j) ~= 0))
            %[row,column] = find(Test_Img == pixelVal);
            Coordinate_Test(index,1) = i-X;
            Coordinate_Test(index,2) = j-Y;
            Coordinate_Test(index,3) = Test_Img(i,j);
            index = index + 1;
%             arr(index) = Test_Img(row(1),column(1));
%             fprintf('row: %d column: %d PixelVal: %d\n', i, j, Test_Img(i,j));
        end
        if(index > index_prev)
            break;
        end
    end
    if(index > index_prev)
        break;
    end
end


Coordinate_tmp = sortrows(Coordinate, 3);
Coordinate_Test_tmp = sortrows(Coordinate_Test, 3);
fprintf('Displaying the Coordinate_Test_tmp array\n');
disp(Coordinate_Test_tmp);

[Coordinate, Coordinate_Test] = getPointsForRotation(Coordinate_tmp, Coordinate_Test_tmp);
fprintf('Displaying the Coordinate_Test array\n');
disp(Coordinate_Test);
figure(1);
imshow(Img_PointsOfInterest);

figure(2);
imshow(Test_Img);
    
Coordinate(:,3) = 1;
Coordinate_Test(:,3) = 1;
[Cm, Cn] = size(Coordinate);
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

M(3,1) = 0;

M(3,2) = 0;

[Test_Img_2] = imagePreProcessing('sailboat_2.jpg');
figure(3);
imshow(Test_Img_2);
[tm,tn] = size(Test_Img_2);

index = 1;

New_Img = zeros(tm,tn);
for i = 1:tm
    for j = 1:tn
        if(Test_Img_2(i,j) ~= 0)
            P = [i-X j-Y 1]*M;
            Coordinate_Test_2(index,1) = P(1);
            Coordinate_Test_2(index,2) = P(2);
            Coordinate_Test_2(index,3) = P(3);
            New_Img(floor(P(1)+X), floor(P(2)+Y)) = 1;
            index = index + 1;
        end
    end
end

fprintf('The value of M is:\n');
disp(M);

figure(4);
imshow(New_Img);