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
fprintf(fid, 'P3 %d %d %d\n', (width+1)*num_components, width, 255);

% Print image data (no line over 70 chars as per standard)
cur_char = 0;
for row=0:width-1
    offset = row*width;
    for component = 1:num_components
        for col=1:width
            fprintf(fid,'%4d%4d%4d', red(offset+col, component), green(offset+col, component), 0);
            cur_char = cur_char + 12;
            if(cur_char >= (70-12))
                fprintf(fid, '\n');
                cur_char = 0;
            end
        end
        fprintf(fid, ' 0 0 255\n');
        cur_char = 0;
    end
    fprintf(fid, '\n');
    cur_char = 0;
end


fclose(fid);
end

