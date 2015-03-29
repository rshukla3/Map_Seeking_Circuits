clc;
clear all;
close all;
% 
[Preprocessed_Img, Noisy] = image_rgb2gray_noisy('car_2__fixed_2.jpg');
[Preprocessed_Img, Noisy_1] = image_rgb2gray_noisy('car_2__fixed_5.jpg');
Test_Img = Noisy;
%[Preprocessed_Img] = image_rgb2gray('sailboat_2.jpg');
%est_Img = (imrotate(Preprocessed_Img, 45, 'bilinear', 'crop'));
%Test_Img = translate_img(Test_Img, 100, 0);

% Test_Img = single(scaleImg(Preprocessed_Img, 0.6, 0.6));
[fa, da] = vl_sift(single(Preprocessed_Img)) ;
[fb, db] = vl_sift(single(Test_Img)) ;
[matches, scores] = vl_ubcmatch(da, db) ;

figure(10);
imshow(Preprocessed_Img); hold on;
perm = randperm(size(fa,2)) ;
sel = perm(1:8) ;
h1 = vl_plotframe(fa(:,sel)) ;
h2 = vl_plotframe(fa(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;

figure(11);
imshow(Test_Img); hold on;
perm = randperm(size(fb,2)) ;
sel = perm(1:8) ;
h1 = vl_plotframe(fb(:,sel)) ;
h2 = vl_plotframe(fb(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;



[M,TFORM] = sift_mosaic(Preprocessed_Img, Test_Img);

TFORM.T


















% sortedValues = [matches; scores];
% [Y,I] = sort(sortedValues(3,:), 'descend');
% 
% sortedValues = sortedValues(:,I);
% 
% 
% figure(10);
% imshow(Preprocessed_Img); hold on;
% h1 = vl_plotframe(fa(:,sortedValues(1,1:6))) ;
% h2 = vl_plotframe(fa(:,sortedValues(1,1:6))) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% 
% figure(12);
% imshow(Test_Img); hold on;
% h1 = vl_plotframe(fb(:,sortedValues(2,1:6))) ;
% h2 = vl_plotframe(fb(:,sortedValues(2,1:6))) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% 
% 
% 
% Points_1 = fa(1:2,sortedValues(1,1:2));
% Points_2 = fb(1:2,sortedValues(2,1:2));
% Points_1_r(:,1) = reshape(Points_1(1,:),[2 1]);
% Points_1_r(:,2) = reshape(Points_1(2,:),[2 1]);
% Points_2_r(:,1) = reshape(Points_2(1,:),[2 1]);
% Points_2_r(:,2) = reshape(Points_2(2,:),[2 1]);
% 
% [tform,inlierpoints1,inlierpoints2] = estimateGeometricTransform(fix(Points_1_r),fix(Points_2_r),'similarity') ;
% 
% Points_1(3,:) = single(ones(1,6));
% Points_2(3,:) = single(ones(1,6));
% 
% Points_1_r(:,1) = reshape(Points_1(1,:),[6 1]);
% Points_1_r(:,2) = reshape(Points_1(2,:),[6 1]);
% Points_1_r(:,3) = reshape(Points_1(3,:),[6 1]);
% 
% Points_2_r(:,1) = reshape(Points_2(1,:),[6 1]);
% Points_2_r(:,2) = reshape(Points_2(2,:),[6 1]);
% Points_2_r(:,3) = reshape(Points_2(3,:),[6 1]);
% 
% M = Points_1_r\Points_2_r