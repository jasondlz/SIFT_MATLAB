function [ raw_keypoints,des ] = features_detection( im, octaves, intervals, SIFT_SIGMA )
signal = im;
SIFT_INT_SIGMA = 0.5;   %��ʼͼ��߶�
% antialias_sigma = 0.5;  %��˹ƽ������
% g = gaussian_filter( antialias_sigma );
%    signal = conv2( g, g, im, 'same' );
%    g_test=fspecial('gaussian',[5 5],antialias_sigma);

[X,Y] = meshgrid( 1:0.5:size(signal,2), 1:0.5:size(signal,1) );
signal = interp2( signal, X, Y, '*linear' );   
subsample = 0.5;  % ͼ���²���Ϊ0.5
initial_sigma = sqrt(SIFT_SIGMA * SIFT_SIGMA - SIFT_INT_SIGMA * SIFT_INT_SIGMA * 4);%ģ����������-1�׵�1��ʱsigmaֵ(2M*2N)
%�Գ�ʼͼ�����initial_sigma�ĸ�˹�˲��������õ��ĳ�ʼͼ��ĳ߶�Ϊ1.6����SIFT_SIGMA
g = gaussian_filter( initial_sigma );
signal = conv2( g, g, signal, 'same' );
%�Բ�ͬ�ײ��sigmaֵ���и���
% absolute_sigma = CalSigma( SIFT_SIGMA,octaves,intervals );
%�����˹������
[gauss_pyr,DOG_pyr,absolute_sigma] = GetDOG_pyr( signal,SIFT_SIGMA,octaves,intervals );
%��ʾgauss��������DOG������
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

% ����DOG������Ѱ�������㣬��������о�ȷ��λ���ų���Ե��Ӧ
contrast_threshold = 0.04;
r_threshold = 10;
curvature_threshold = ((r_threshold + 1)^2)/r_threshold;
[contrast_keypoints,curve_keypoints,first_keypoints,subsampleall] = ...
    Getextre_mpoint( DOG_pyr,octaves,intervals,absolute_sigma,subsample,contrast_threshold,curvature_threshold );

% ������������ݶ�ֱ��ͼ���õ�������ķ��򣬶Գ�����ֵ�ĸ���Ϊ��������
raw_keypoints = calc_oris(gauss_pyr,curve_keypoints,absolute_sigma);

%��������������ڳ߶�
for i = 1:size(raw_keypoints,1)
    raw_keypoints(i,8) = absolute_sigma(1,raw_keypoints(i,2));
end

% ����ÿ���������������
des = compute_descriptors ( raw_keypoints,gauss_pyr,4,8 );
