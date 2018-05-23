%ÏÂ²ÉÑù
function [im_downsample] = downsample( im )
[X,Y] = meshgrid( 1:2:size(im,2), 1:2:size(im,1) );
im_downsample = interp2(im,X,Y,'*nearest'); 
end