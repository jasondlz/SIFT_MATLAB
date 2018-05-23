tic;
close all;
clear all;
ors1 = imread('gausstest3.jpg');
ors2 = imread('gausstest4.jpg');
[H,L,M] = size(ors1);
if M == 3
    im1 = rgb2gray(im2double(ors1));
    im2 = rgb2gray(im2double(ors2));
else
    im1 =  im2double(ors1) ;
    im2 =  im2double(ors2) ;    
end
%%
%%参数设置
intervals = 3;  %每阶层数
scl = 1.5;
dist_ratio = 0.8;
octaves1 = floor(log(min(size(im1)))/log(2)- 2);    %阶数
octaves2 = floor(log(min(size(im2)))/log(2)- 2);
SIFT_SIGMA = 1.6;   %初始尺度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%特征检测
[raw_keypoints1,des1 ] = features_detection( im1, octaves1, intervals, SIFT_SIGMA);
[raw_keypoints2,des2 ] = features_detection( im2, octaves2, intervals, SIFT_SIGMA);
% db = add_features_db( im1, pos1, scale1, orient1, desc1 );
%%%%%%%%特征匹配
des_num = features_matching( des1,des2,dist_ratio );
exact_num = find(des_num(:,2));
exact_points1 = zeros(size(exact_num,1),2);
exact_points2 = exact_points1;
for k = 1:size(exact_num,1)
        exact_points1(k,:) = [raw_keypoints1(des_num(exact_num(k),1),3) * raw_keypoints1(des_num(exact_num(k),1),6),...
            raw_keypoints1(des_num(exact_num(k),1),4) * raw_keypoints1(des_num(exact_num(k),1),6)];
        exact_points2(k,:) = [raw_keypoints2(des_num(exact_num(k),2),3) * raw_keypoints2(des_num(exact_num(k),2),6),...
            raw_keypoints2(des_num(exact_num(k),2),4) * raw_keypoints2(des_num(exact_num(k),2),6)];
end
%%%显示粗匹配结果
figure,imshow(ors1),title('figure1')
hold on;
for k = 1:size(raw_keypoints1,1)
    plot(raw_keypoints1(k,3) * raw_keypoints1(k,6), raw_keypoints1(k,4) * raw_keypoints1(k,6),'r^');
end
figure,imshow(ors2),title('figure2')
hold on;
for k = 1:size(raw_keypoints2,1)
    plot(raw_keypoints2(k,3) * raw_keypoints2(k,6), raw_keypoints2(k,4) * raw_keypoints2(k,6),'r^');
end
im3 = zeros(max(size(im1,1),size(im2,1)),size(im1,2) + size(im2,2) + 10,M);
im3(1:size(im1,1),1:size(im1,2),:) = im2double(ors1(:,:,:));
im3(1:size(im2,1),size(im1,2)+ 11:size(im1,2)+size(im2,2) + 10 ,:) = im2double(ors2(:,:,:));
figure,imshow(im3),title('粗匹配结果')
% x横坐标，y纵坐标，画线
for i=1:size(exact_num,1)
    line([exact_points1(i,1),size(im1,2)+10+exact_points2(i,1)], [exact_points1(i,2),exact_points2(i,2)],'Color',[1 0 0],'LineWidth',1)
%     line([exact_points1(i,1),size(im1,2)+10+exact_points2(i,1)], [exact_points1(i,2),exact_points2(i,2)],'Color',rand(1,3),'LineWidth',1)
end
%%%%%RANSAC算法去错匹配
[corners1,corners2]= Ransac(exact_points1,exact_points2,200,1);
figure,imshow(im3),hold on,colormap gray,title('Ransac算法去错结果')
 for n = 1:length(corners2)
     line([corners1(n,1) corners2(n,1) + 10 + size(im1,2)], [corners1(n,2) corners2(n,2)],'Color',[1 1 0])
 end
%%图像拼接
ImageBlenging = LMBlending(ors1,ors2,corners1,corners2);
figure,imshow(ImageBlenging),title('LM加权融合结果'),colormap gray
size(corners1,1)
size(exact_points1,1)
toc;



