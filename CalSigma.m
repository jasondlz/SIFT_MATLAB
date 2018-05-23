%计算所有octave和interval的sigma
function [absolute_sigma] = CalSigma( initial_sigma,octaves,intervals )
absolute_sigma = zeros(octaves,intervals+3);
absolute_sigma(1,1) = initial_sigma;
for octave=1:octaves
    for interval=1:(intervals+3)
        absolute_sigma(octave,interval) = initial_sigma*2^(octave-1+(interval-1)/3);
    end
end   
end