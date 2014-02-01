function plot_shifted_1_coeffs( filename, coeff )
% Plots the coefficients of the principal components (from PCA of shifted_1_dataset) as a PPM file
%
% Negative is red. Positive is green and blue separates components.
%
% I wrote this because I was hoping it would be obvious when the
% components were fitting noise just by visual inspection. Unfortunately,
% that is not so obvious.
%
% coeff - (square matrix) the matrix of coefficients from running princomp
%     on a shifted_1_dataset

% Calculate the width of the component images
width = round(sqrt(size(coeff,1)));
num_components = size(coeff, 2);

% Make coefficients integers between 0 and 255 inclusive. Red represents
% intensity in negative and green in the positive
red = zeros(size(coeff));
red(coeff < 0) = -coeff(coeff < 0);
red = red - min(min(red));
red = red / max(max(red));
red = round(red * 255);

green = zeros(size(coeff));
green(coeff > 0) = coeff(coeff > 0);
green = green - min(min(green));
green = green / max(max(green));
green = round(green * 255);

fid = fopen(filename,'w');

% Print header
num_master_rows = ceil(num_components/10);
fprintf(fid, 'P3 %d %d %d\n', (width+1)*10-1, (width+1)*num_master_rows, 255);

% Create blank image. pict(:,:,1) is red. pict(:,:,2) is green, etc
% First coord is x coord, second is y (rather than standard matrix indices)
pict = zeros((width+1)*10-1, (width+1)*num_master_rows, 3);

% Make the picture blue where it is not overwritten
pict(:,:,3) = 255;

% Overwrite the picture data in the areas where there is a component image
for component = 1:num_components
    % 0 based x and y coordinates of the sub-image
    subimage_y = floor((component-1)/10);
    subimage_x = mod(component-1, 10);
    
    % 1 based indices into the pict for the upper-left pixel of the current
    % subimage - the ul pixel is accessed at pict(pict_ul_x, pict_ul_y)
    pict_ul_x = subimage_x*(width+1)+1;
    pict_ul_y = subimage_y*(width+1)+1;
    
    for pixel = 1:size(coeff,1)
        pixel_y = floor((pixel-1)/width);
        pixel_x = mod(pixel-1, width);
        
        pict(pict_ul_x+pixel_x, pict_ul_y+pixel_y,:)=[...
            red(pixel, component) green(pixel, component) 0];
    end
end

% Write out the pixels
cur_char = 0;
for y = 1:size(pict,2)
    for x = 1:size(pict,1)
        fprintf(fid,'%4d%4d%4d', pict(x,y,1), pict(x,y,2), pict(x,y,3));
        cur_char = cur_char + 12;
        if(cur_char >= (70-12))
            fprintf(fid, '\n');
            cur_char = 0;
        end
    end
    fprintf(fid, '\n');
    cur_char = 0;
end

fclose(fid);
end

