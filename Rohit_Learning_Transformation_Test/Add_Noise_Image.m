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

[Preprocessed_Img] = imagePreProcessing('monopoly_robot.jpg');

figure(1);
imshow(Preprocessed_Img);