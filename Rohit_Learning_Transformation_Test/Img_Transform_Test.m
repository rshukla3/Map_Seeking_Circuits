P1 = imagePreProcessing('pepper_2.jpg');
P2 = single(imrotate(P1, 0, 'nearest', 'crop'));
[coordinates]= getPointsOfInterest(P1);
[m,n] = size(P1);

C3 = imageFeatExtractProcessing(P1);
T2 = single(imrotate(P1, -34, 'nearest', 'crop'));
Learned_Transformation_Matrix_Forward = ([0.87   -0.6         0
                                         0.6    0.87         0
                                        0         0    1]);
T = (img_transform(coordinates, m, n, Learned_Transformation_Matrix_Forward));
% T = imwarp(P1,Learned_Transformation_Matrix_Forward);
%D1 = dotproduct(P2, T)
D2 = dotproduct(P2, P2)
figure(1);
imshow(P2);

figure(2);
imshow(T);

figure(4);
imshow(C3);