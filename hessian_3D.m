% º∆À„Hessianæÿ’Û
function H = hessian_3D(DOG_pyr,octave,interval,x,y)
dxx = (DOG_pyr{octave,interval}(y,x+1) + DOG_pyr{octave,interval}(y,x-1) - 2 * DOG_pyr{octave,interval}(y,x));
dyy = (DOG_pyr{octave,interval}(y+1,x) + DOG_pyr{octave,interval}(y-1,x) - 2 * DOG_pyr{octave,interval}(y,x));
dss = (DOG_pyr{octave,interval+1}(y,x) + DOG_pyr{octave,interval-1}(y,x) - 2 * DOG_pyr{octave,interval}(y,x));
dxy = (DOG_pyr{octave,interval}(y+1,x+1) + DOG_pyr{octave,interval}(y-1,x-1) - DOG_pyr{octave,interval}(y+1,x-1) - DOG_pyr{octave,interval}(y-1,x+1))/4;
dxs = (DOG_pyr{octave,interval+1}(y,x+1) + DOG_pyr{octave,interval-1}(y,x-1) - DOG_pyr{octave,interval+1}(y,x-1) - DOG_pyr{octave,interval-1}(y,x+1))/4;
dys = (DOG_pyr{octave,interval+1}(y+1,x) + DOG_pyr{octave,interval-1}(y-1,x) - DOG_pyr{octave,interval+1}(y-1,x) - DOG_pyr{octave,interval-1}(y+1,x))/4;
H = [ dxx dxy dxs; dxy dyy dys; dxs dys dss ];
end