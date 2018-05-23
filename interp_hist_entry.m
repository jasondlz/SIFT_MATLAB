function hist = interp_hist_entry(hist,xbin,ybin,obin,mag,d,n)
x0 = floor(xbin);
d_x = xbin - x0;
y0 = floor(ybin);
d_y = ybin - y0;
o0 = floor(obin);
d_o = obin - o0;
for y = 0:1
    yb = y0 + y;
    if yb >=0 && yb < d
        if y == 0
            v_y = mag * (1 - d_y);
        else
            v_y = mag * d_y;
        end        
        for x = 0:1
            xb = x0 + x;
            if xb >= 0 && xb < d
                if x == 0
                    v_x = v_y * (1 - d_x);
                else
                    v_x = v_y * d_x;
                end
                    for o = 0:1
                        ob = rem(( o0 + o ),n);
                        if o == 0
                            v_o = v_x * (1 - d_o);
                        else
                            v_o = v_x * d_o;
                        end
                        hist(yb+1,xb+1,ob+1) = hist(yb+1,xb+1,ob+1) + v_o;
                    end
            end
        end      
    end
end
end