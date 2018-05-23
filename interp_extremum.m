% 利用泰勒展开对特征点精确定位
function [delta_oxys] = interp_extremum( DOG_pyr,octave,interval,x,y,intervals,contrast_threshold )
interptime = 0;
while interptime < 5
    dD = deriv_3D(DOG_pyr,octave,interval,x,y);
    H = hessian_3D(DOG_pyr,octave,interval,x,y);
    delta_xys = - H\dD;
    if ( abs(delta_xys(1)) < 0.5 && abs(delta_xys(2)) < 0.5 && abs(delta_xys(3)) < 0.5 )
        break;
    end
        x = x + round(delta_xys(1));
        y = y + round(delta_xys(2));
        interval = interval + round(delta_xys(3));
        if ( interval <= 1 || interval >= (intervals+2) || x <= 1 || y <= 1 || x >= size(DOG_pyr{octave,interval},2) || y >= size(DOG_pyr{octave,interval},1)...
                || isnan(x) || isnan(y) || isnan(interval))
            delta_oxys = [];
            return
        end
        interptime = interptime+1;
end
if ( interptime >= 5 )
   delta_oxys = [];
   return
end
dD = deriv_3D(DOG_pyr,octave,interval,x,y);
contr = DOG_pyr{octave,interval}(y,x) + 0.5 * dD' * delta_xys;
if( abs(contr) < contrast_threshold/intervals)
    delta_oxys = [];
   return
end
delta_oxys = [octave,interval,x,y];

end