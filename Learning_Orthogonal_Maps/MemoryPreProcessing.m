function [ Memory_Img ] = MemoryPreProcessing( Input_Img )
%Does the preprocessing on input images. PreProcessing involves performing
%filtering on the image and later doing edge detection on it.

Memory_Img_gray = rgb2gray(Input_Img);

[Im, In] = size(Memory_Img_gray);

[~, Thresh] = edge(Memory_Img_gray, 'prewitt');
Memory_Img_BW = edge(Memory_Img_gray, 'prewitt', Thresh*0.5);
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Memory_Img_dilate = imdilate(Memory_Img_BW, [se90 se0]);
Memory_Img_Fill = imfill(Memory_Img_dilate, 'holes');
seD = strel('diamond',1);
Memory_Img_Final = imerode(Memory_Img_Fill,seD);
Memory_Img_Erode = imerode(Memory_Img_Final,seD);
BWoutline = edge(Memory_Img_Erode);
Memory_Img = logical(zeros(Im, In));
Memory_Img(BWoutline) = 1;


figure(1);
imshow(Memory_Img);

end

