% 计算x,y,sigma三个方向的偏导数，即差分
function dD = deriv_3D(DOG_pyr,octave,interval,x,y)
dx = (DOG_pyr{octave,interval}(y,x+1) - DOG_pyr{octave,interval}(y,x-1))/2;
dy = (DOG_pyr{octave,interval}(y+1,x) - DOG_pyr{octave,interval}(y-1,x))/2;
ds = (DOG_pyr{octave,interval+1}(y,x) - DOG_pyr{octave,interval-1}(y,x))/2;
dD = [dx;dy;ds];
end