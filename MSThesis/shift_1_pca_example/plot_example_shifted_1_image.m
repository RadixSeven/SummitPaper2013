function plot_example_shifted_1_image( )
% Plots an example shifted 1 image and saves it to a file

oldseed = rng(12341248);

w=25; [~,m]=shifted_1(9,9,w,0.05); image(m*60)
title('Example Shifted 1 Image');
print(1, 'shifted_1_image_example.pdf', '-dpdf');

rng(oldseed);
end

