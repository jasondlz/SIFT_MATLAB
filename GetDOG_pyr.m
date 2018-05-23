%计算gauss金字塔
function [gauss_pyr,DOG_pyr,absolute_sigma] = GetDOG_pyr( initial_gauss,sigma,octaves,intervals )
absolute_sigma = zeros(octaves,intervals+3);
for octave = 1:octaves
    for interval = 1:(intervals+3)
        absolute_sigma(octave,interval) = 2^(octave-1) * 2^((interval-1)/intervals) * sigma;
        if octave == 1 && interval == 1
            gauss_pyr{octave,interval} = initial_gauss;
        elseif interval == 1
            gauss_pyr{octave,interval} = downsample(gauss_pyr{octave-1,intervals+1});
        else
            sig = sqrt(absolute_sigma(octave,interval) * absolute_sigma(octave,interval) - absolute_sigma(octave,interval-1) * absolute_sigma(octave,interval-1));
            g = gaussian_filter(sig);
            gauss_pyr{octave,interval} = conv2( g, g, gauss_pyr{octave,interval-1}, 'same' );
        end
    end
end
% 构造DoG金字塔
for octave = 1:octaves    
    for interval = 1:(intervals+2)
        DOG_pyr{octave,interval} = gauss_pyr{octave,interval+1}-gauss_pyr{octave,interval};
    end
end
end