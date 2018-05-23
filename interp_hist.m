% 利用泰勒展开计算主方向的精确位置
function max_direction = interp_hist( hist_orient,maxnum )
    if maxnum == 1
        lhist = hist_orient(size(hist_orient,2));
    else
        lhist = hist_orient(maxnum - 1);
    end
    if maxnum == size(hist_orient,2)
        rhist = hist_orient(1);
    else
        rhist = hist_orient(maxnum + 1);
    end
    max_hist_num = maxnum + 0.5 * (lhist - rhist)/(lhist - 2 * hist_orient(maxnum) + rhist) - 1;
    if max_hist_num < 0 
        max_hist_num = max_hist_num + size(hist_orient,2);
    elseif max_hist_num >= size(hist_orient,2)
        max_hist_num = max_hist_num -size(hist_orient,2);
    end
    max_direction = (max_hist_num * 2 * pi)/size(hist_orient,2) - pi;
end