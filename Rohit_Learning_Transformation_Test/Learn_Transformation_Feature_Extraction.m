clc;
clear all;
close all;

[Preprocessed_Img, Noisy] = image_rgb2gray_noisy('139_r0.png');
[Preprocessed_Img_1, Noisy] = image_rgb2gray_noisy('145_r0.png');
% [Test_Img] = image_rgb2gray('monopoly_battleShip.jpg');

% % Test_Img = translate_img(Preprocessed_Img, 160, 0);
% Test_Img = (imrotate(Preprocessed_Img, 45, 'bilinear', 'crop'));
% 
% C1 = corner(Preprocessed_Img, 'QualityLevel', 0.5)
% C2 = corner(Test_Img, 'QualityLevel', 0.5)
% 
% 
% 
% p1 = sortrows(C1,[2 1]);
% p2 = sortrows(C2,[2 1]);
% idx = convhull(p1(:,1), p1(:,2)); p1 = p1(idx(1:end-1),:);
% idx = convhull(p2(:,1), p2(:,2)); p2 = p2(idx(1:end-1),:);
% 
% sz = min(size(p1,1),size(p2,1));
% p1 = p1(1:sz,:); p2 = p2(1:sz,:);
% 
% t = fitgeotrans(p2,p1,'affine');    %# 'affine'
% 
% %# rotate image to match the other
% Tinv  = t.invert.T;
% 
% ss = Tinv(2,1);
% sc = Tinv(1,1);
% scale_recovered = sqrt(ss*ss + sc*sc)
% theta_recovered = atan2(ss,sc)*180/pi
% outputView = imref2d(size(Preprocessed_Img));
% recovered  = imwarp(Test_Img,t,'OutputView',outputView);
% 
% 
% %# recover affine transformation params (translation, rotation, scale)
% figure(1);
% imshow(Preprocessed_Img);
% hold on
% plot(p1(:,1), p1(:,2), 'r*');
% 
% figure(2);
% imshow(Test_Img);
% hold on
% plot(p2(:,1), p2(:,2), 'g*');
% figure(3);
% imshow(recovered);
Test_Img = Noisy;
%Test_Img_1 = (scaleImg(Noisy, 0.6, 0.6));
%Test_Img = (imrotate(Test_Img, -30, 'bilinear', 'crop'));
%Test_Img = translate_img_grayScale(Test_Img_2, -100, 100);

% Preprocessed_Img = Noisy;

ptsOriginal  = detectSURFFeatures(Preprocessed_Img);
ptsDistorted = detectSURFFeatures(Test_Img);
figure(10);
imshow(Preprocessed_Img); hold on;
plot(ptsOriginal.selectStrongest(10));

figure(12);
imshow(Test_Img); hold on;
plot(ptsDistorted.selectStrongest(10));

[featuresOriginal,   validPtsOriginal]  = extractFeatures(Preprocessed_Img,  ptsOriginal);
[featuresDistorted, validPtsDistorted]  = extractFeatures(Test_Img, ptsDistorted);

indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

% [iDm, iDn] = size(matchedDistorted.Location);
% [iOm, iOn] = size(matchedOriginal.Location);

% matchedDistorted.Location = matchedDistorted.Location - 256.*ones(iDm, iDn);
% matchedOriginal.Location = matchedOriginal.Location - 256.*ones(iOm, iOn);

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity');
% F = estimateFundamentalMatrix(matchedDistorted,matchedOriginal)
% [tform_1, inlierOriginal_1, inlierDistorted_1] = estimateGeometricTransform(matchedOriginal, matchedDistorted.Location, 'similarity');
tform.invert.T
[iDm, iDn] = size(inlierDistorted.Location);
[iOm, iOn] = size(inlierOriginal.Location);

iDistorted = (inlierDistorted.Location - 256.*ones(iDm, iDn));
iOriginal = (inlierOriginal.Location - 256.*ones(iOm, iOn));

iDistorted(:,3) = 1;
iOriginal(:,3) = 1;

T1 = round2(iDistorted\iOriginal, 0.01)
T2 = round2(iOriginal\iDistorted, 0.01)

figure(4);
showMatchedFeatures(Preprocessed_Img,Test_Img, inlierOriginal, inlierDistorted);
title('Matching points (inliers only)');
legend('ptsOriginal','ptsDistorted');
figure(1);
imshow(Test_Img); hold on;
plot(inlierDistorted.selectStrongest(10));

figure(2);
imshow(Preprocessed_Img); hold on;
plot(inlierOriginal.selectStrongest(10));

Tinv  = tform.invert.T
% Tinv_1  = tform_1.invert.T;

ss = T1(2,1);
sc = T1(1,1);
scale_recovered = sqrt(ss*ss + sc*sc)
theta_recovered = atan2(ss,sc)*180/pi
