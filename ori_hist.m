% 构建特征点的梯度直方图
function [hist_orient] = ori_hist(gaussim,x,y,sigma,num_bins)
rad = 3 * 1.5 * sigma;
hist_orient = zeros(1,num_bins);
for i = -round(rad) : 1 : round(rad)
    for j = -round(rad) : 1 : round(rad)
        if (i+x) > 1 && (i+x) < (size(gaussim,2)-1) && (j+y) > 1 && (j+y) < (size(gaussim,1)-1)
            dx = (gaussim(y+j,x+i+1) - gaussim(y+j,x+i-1))/2;
            dy = (gaussim(y+j+1,x+i) - gaussim(y+j-1,x+i))/2;
            mag = sqrt(dx*dx + dy*dy);
            ori = atan2(dy,dx);
            w = exp(-(i*i + j*j)/(2 * sigma * sigma));
            bin = floor(num_bins * (ori + pi)/(2*pi))+1;
            if bin > num_bins
                bin = 1;
            end
            hist_orient(bin) = hist_orient(bin) + w * mag;
        end
    end
end


end