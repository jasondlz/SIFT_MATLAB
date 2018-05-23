%检测极值点，初步定位特征点，然后用泰勒展开精确定位极值点，并去除边缘响应
function [contrast_keypoints,curve_keypoints,first_keypoints,subsampleall] = Getextre_mpoint( DOG_pyr,octaves,intervals,absolute_sigma,subsample,contrast_threshold,curvature_threshold )
pre_threshold = 0.5 * contrast_threshold / intervals;
contrast_keypoints = [];
curve_keypoints = [];
first_keypoints = [];
tmp=zeros(3,3,3);
for octave = 1:octaves
    subsampleall(octave) = subsample^(2-octave);
    for interval = 2:(intervals+1)
        for x = 2:size(DOG_pyr{octave,interval},2)-1
            for y = 2:size(DOG_pyr{octave,interval},1)-1
                if abs(DOG_pyr{octave,interval}(y,x)) > pre_threshold
                    for i = 1:3
                        tmp(:,:,i) = DOG_pyr{octave,interval+i-2}((y-1):(y+1),(x-1):(x+1));
                    end
                    if (tmp(2,2,2) == min(tmp(:))) || (tmp(2,2,2) == max(tmp(:)))
%                         first_keypoints = [ first_keypoints;octave,interval,x,y,subsampleall(octave) ];                       
                        delta_oxys = interp_extremum( DOG_pyr,octave,interval,x,y,intervals,contrast_threshold );
                        if size(delta_oxys,2)
                            contrast_keypoints = [ contrast_keypoints;delta_oxys,absolute_sigma(octave,interval),subsampleall(octave) ];
                            xx = [ 1 -2  1 ];
                            yy = xx';
                            xy = [ 1 0 -1; 0 0 0; -1 0 1 ]/4;
                            Dxx = sum(DOG_pyr{delta_oxys(1),delta_oxys(2)}(delta_oxys(4),(delta_oxys(3)-1):(delta_oxys(3)+1)) .* xx);
                            Dyy = sum(DOG_pyr{delta_oxys(1),delta_oxys(2)}((delta_oxys(4)-1):(delta_oxys(4)+1),delta_oxys(3)) .* yy);
                            Dxy = sum(sum(DOG_pyr{delta_oxys(1),delta_oxys(2)}((delta_oxys(4)-1):(delta_oxys(4)+1),(delta_oxys(3)-1):(delta_oxys(3)+1)) .* xy));
                            %计算Hessian矩阵的迹和行列式
                            Tr_H = Dxx + Dyy;
                            Det_H = Dxx * Dyy - Dxy^2;
                            curvature_ratio = (Tr_H^2)/Det_H;
                            if (Det_H >= 0) && (curvature_ratio < curvature_threshold)
                               %去掉边缘点
                               curve_keypoints = [curve_keypoints; contrast_keypoints(end,:)];
                            end
                        end
                    end
                end
            end
        end
    end
end
end