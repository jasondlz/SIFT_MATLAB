function [ raw_keypoints,des ] = features_detection( im, octaves, intervals, SIFT_SIGMA )
signal = im;
SIFT_INT_SIGMA = 0.5;   %初始图像尺度
% antialias_sigma = 0.5;  %高斯平滑参数
% g = gaussian_filter( antialias_sigma );
%    signal = conv2( g, g, im, 'same' );
%    g_test=fspecial('gaussian',[5 5],antialias_sigma);

[X,Y] = meshgrid( 1:0.5:size(signal,2), 1:0.5:size(signal,1) );
signal = interp2( signal, X, Y, '*linear' );   
subsample = 0.5;  % 图像下采样为0.5
initial_sigma = sqrt(SIFT_SIGMA * SIFT_SIGMA - SIFT_INT_SIGMA * SIFT_INT_SIGMA * 4);%模糊金字塔第-1阶第1层时sigma值(2M*2N)
%对初始图像进行initial_sigma的高斯滤波，这样得到的初始图像的尺度为1.6，即SIFT_SIGMA
g = gaussian_filter( initial_sigma );
signal = conv2( g, g, signal, 'same' );
%对不同阶层的sigma值进行跟踪
% absolute_sigma = CalSigma( SIFT_SIGMA,octaves,intervals );
%计算高斯金字塔
[gauss_pyr,DOG_pyr,absolute_sigma] = GetDOG_pyr( signal,SIFT_SIGMA,octaves,intervals );
%显示gauss金字塔和DOG金字塔
% for octave = 1:octaves
%     imshow_gausspyr{octave} = [];
%     imshow_DOGpyr{octave} = [];
%     for interval = 1:(intervals+3)
%         imshow_gausspyr{octave} = [imshow_gausspyr{octave} gauss_pyr{octave,interval}];
%         if interval < (intervals+3)
%             imshow_DOGpyr{octave} = [imshow_DOGpyr{octave} DOG_pyr{octave,interval}];
%         end
%     end
%     figure(1);
%     subplot(octaves,1,octave);
%     imshow(imshow_gausspyr{octave});
%     figure(2);
%     subplot(octaves,1,octave);
%     imshow(abs(imshow_DOGpyr{octave}));
% end
% DOG_pyr_test = DOG_pyr;
% gauss_pyr_test = gauss_pyr;

% 利用DOG金字塔寻找特征点，特征点进行精确定位并排除边缘响应
contrast_threshold = 0.04;
r_threshold = 10;
curvature_threshold = ((r_threshold + 1)^2)/r_threshold;
[contrast_keypoints,curve_keypoints,first_keypoints,subsampleall] = ...
    Getextre_mpoint( DOG_pyr,octaves,intervals,absolute_sigma,subsample,contrast_threshold,curvature_threshold );

% 构建特征点的梯度直方图，得到特征点的方向，对超过阈值的复制为新特征点
raw_keypoints = calc_oris(gauss_pyr,curve_keypoints,absolute_sigma);

%加入特征点的组内尺度
for i = 1:size(raw_keypoints,1)
    raw_keypoints(i,8) = absolute_sigma(1,raw_keypoints(i,2));
end

% 计算每个特征点的描述子
des = compute_descriptors ( raw_keypoints,gauss_pyr,4,8 );
