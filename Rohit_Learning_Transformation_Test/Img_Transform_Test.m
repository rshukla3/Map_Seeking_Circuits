P1 = imagePreProcessing('pepper_2.jpg');
[coordinates]= getPointsOfInterest(P1);
[m,n] = size(P1);
Learned_Transformation_Matrix_Forward = [0.9800   -0.2500         0
                                         0.2500    0.9800         0
                                        0         0    1];
T = (img_transform(coordinates, m, n, Learned_Transformation_Matrix_Forward));

figure(1);
imshow(P1);

figure(2);
imshow(T);