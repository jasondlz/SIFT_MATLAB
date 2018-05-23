function [des] = compute_descriptors ( raw_keypoints,gauss_pyr,d,n )
% mul = ones(size(raw_keypoints));
% mul(:,3:4) = [raw_keypoints(:,6),raw_keypoints(:,6)];
% raw_keypoints = raw_keypoints .* mul;
SIFT_DESCR_SCL_FCTR = 3;
des = zeros(size(raw_keypoints,1),128);
for num = 1 : size(raw_keypoints,1)
    gaussim = gauss_pyr{raw_keypoints(num,1),raw_keypoints(num,2)};
    x = raw_keypoints(num,3);
    y = raw_keypoints(num,4);
    hist_width = SIFT_DESCR_SCL_FCTR * raw_keypoints(num,8);
    radius = floor(hist_width * sqrt(2) * (d + 1) * 0.5 + 0.5);
    bins_per_rad = n / (2 * pi);
    exp_denom = d * d * 0.5;
    hist = zeros(d,d,n);
    % x->j   y->i
    for i = -radius : radius
        for j = -radius : radius
            % x->c y->r
            x_rot = ( j * cos(raw_keypoints(num,7)) - i * sin(raw_keypoints(num,7)) ) / hist_width;
            y_rot = ( j * sin(raw_keypoints(num,7)) + i * cos(raw_keypoints(num,7)) ) / hist_width;
            xbin = x_rot + d/2 + 0.5;
            ybin = y_rot + d/2 + 0.5;
            if ( xbin > -1 && xbin < d && ybin > -1 && ybin < d )
                if x+j > 1 && x+j < size(gaussim,2) && y+i > 1 && y+i < size(gaussim,1)
                    dy = (gaussim(y+i+1,x+j) - gaussim(y+i-1,x+j))/2;
                    dx = (gaussim(y+i,x+j+1) - gaussim(y+i,x+j-1))/2;
                    mag = sqrt(dx*dx + dy*dy);
                    ori = atan2(dy,dx);
                    ori = ori + pi;
                    if ori == 2*pi
                        ori = 0;
                    end
                else
                    continue
                end
                obin = ori * bins_per_rad;
                w = exp( -(x_rot * x_rot + y_rot * y_rot)/ exp_denom );
                hist = interp_hist_entry(hist,xbin,ybin,obin,mag*w,d,n);
            end
        end
    end
    des(num,:) = reshape(hist,[1,128]);
    des(num,:) = des(num,:) ./ sqrt(sum(des(num,:) .* des(num,:)));
    des(num,:) = min(des(num,:),0.2);
    des(num,:) = des(num,:) ./ sqrt(sum(des(num,:) .* des(num,:)));
    des(num,:) = des(num,:) .* 512;
    des(num,:) = round(min(des(num,:),255));
end

end