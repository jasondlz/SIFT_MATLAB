% ������������ݶ�ֱ��ͼ���ҳ�������
function [raw_keypoints] = calc_oris(gauss_pyr,curve_keypoints,absolute_sigma)
num_bins = 36;
n = size(curve_keypoints,1);
soomthtimes = 2;
raw_keypoints = [];
mag_thr = 0.8;
for num = 1:n
    hist_orient = ori_hist(gauss_pyr{curve_keypoints(num,1),curve_keypoints(num,2)},curve_keypoints(num,3),...
        curve_keypoints(num,4),absolute_sigma(curve_keypoints(num,1),curve_keypoints(num,2)),num_bins);
    for smoothtime = 1:2
        for i = 1 : num_bins
            if i == 1
                lhist = hist_orient(num_bins);
            else
                lhist = hist_orient(i-1);
            end
            if i == num_bins
                rhist = hist_orient(1);
            else
                rhist = hist_orient(i+1);
            end
            % ��������ݶ�ֱ��ͼ��������ƽ����ֵ
            hist_orient(i) = 0.25 * lhist + 0.5 * hist_orient(i) + 0.25 * rhist;
        end
    end
    maxhist = 0;
    maxhistnum = 0;
    % Ѱ���ݶ�ֱ��ͼ�ļ�ֵ����ֵ���ڵ����±�
    for i = 1 : num_bins
        if hist_orient(i) > maxhist
            maxhist = hist_orient(i);
            maxhistnum = i;
        end
    end
    for i = 1 : num_bins
        if i == 1
            lhist = hist_orient(num_bins);
        else
            lhist = hist_orient(i-1);
        end
        if i == num_bins
            rhist = hist_orient(1);
        else
            rhist = hist_orient(i+1);
        end
        if hist_orient(i) > lhist && hist_orient(i) > rhist && hist_orient(i) > mag_thr * maxhist
            orient = interp_hist( hist_orient,i );
            raw_keypoints = [raw_keypoints;curve_keypoints(num,:),orient];            
        end
    end
end
end
