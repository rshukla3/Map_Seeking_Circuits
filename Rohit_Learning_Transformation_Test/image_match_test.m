clc;
clear all;

[Preprocessed_Img, Memory_PreProcessed_Img] = imagePreProcessing('monopoly_battleShip.jpg');
Img_PointsOfInterest = Preprocessed_Img;
%% Perform affine transformations on this memory image.
% Since we do not have any movie of the memory images, so we will be
% generating test images with affine transformations on memory image
% itself. Later we will test our learned transforms on these MATLAB
% generated affine transformations.
% Test_Img = Img_PointsOfInterest;


Rotation = -30;
Test_Img_1 = single(imrotate(Img_PointsOfInterest, Rotation, 'nearest', 'crop'));
Learning_Test_Img_1 = single(imrotate(Memory_PreProcessed_Img, Rotation, 'nearest', 'crop'));
 
x_Translation = 100;
y_Translation = 100;
Test_Img_2 = translate_img(Test_Img_1, x_Translation, y_Translation);
Learning_Test_Img_2 = translate_img(Learning_Test_Img_1, x_Translation, y_Translation);

Scaling = 0.8;
Test_Img = scaleImg(Test_Img_2, Scaling, Scaling);
Learning_Test_Img = scaleImg(Learning_Test_Img_2, Scaling, Scaling);

Rotation = -30;
Test_Img_1 = single(imrotate(Img_PointsOfInterest, Rotation, 'nearest', 'crop'));
Learning_Test_Img_1 = single(imrotate(Memory_PreProcessed_Img, Rotation, 'nearest', 'crop'));

Scaling = 0.8;
Test_Img_2 = scaleImg(Test_Img_1, Scaling, Scaling);
Learning_Test_Img_2 = scaleImg(Learning_Test_Img_1, Scaling, Scaling);
 
x_Translation = 100;
y_Translation = 100;
Test_Img_T = translate_img(Test_Img_2, x_Translation, y_Translation);
Learning_Test_Img_T = translate_img(Learning_Test_Img_2, x_Translation, y_Translation);


Scaling = 0.8;
Test_Img_1 = scaleImg(Img_PointsOfInterest, Scaling, Scaling);
Learning_Test_Img_1 = scaleImg(Memory_PreProcessed_Img, Scaling, Scaling);

Rotation = -30;
Test_Img_2 = single(imrotate(Test_Img_1, Rotation, 'nearest', 'crop'));
Learning_Test_Img_2 = single(imrotate(Learning_Test_Img_1, Rotation, 'nearest', 'crop'));
 
x_Translation = 100;
y_Translation = 100;
Test_Img_T_1 = translate_img(Test_Img_2, x_Translation, y_Translation);
Learning_Test_Img_T_1 = translate_img(Learning_Test_Img_2, x_Translation, y_Translation);

D_D = dotproduct(Test_Img, Test_Img_T)
D_D_1 = dotproduct(Test_Img_T_1, Test_Img_T)
D_D_2 = dotproduct(Test_Img_T_1, Test_Img)
D_1 = dotproduct(Test_Img, Test_Img)
D_2 = dotproduct(Test_Img_T, Test_Img_T)
