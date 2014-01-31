function [shifted_1_vector, shifted_1_matrix] = shifted_1( row_offset, column_offset, host_matrix_size, fraction_noise)
% Creates a noisy matrix with the number 1 located somewhere within.
%
% At row_offset, column_offset copies an image of the number 1 (composed of 
% 0's and 1's) into a square host matrix of zeros (size: 
% host_matrix_size x host_matrix_size). Then randomly flips fraction_noise
% of the bits (that is, if fraction_noise is 0.3 then for each entry in the
% matrix, there is a 30% chance it will be flipped.)
%
% At the edges of the host matrix, the 1 matrix is clipped (rather than
% wrapping). The 1 image is 12 rows by 8 columns.
%
% An easy way to visualize the matrix (if it is stored in m) is to type 
% image(m*60)
%
% ------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------
%
% row_offset - (integer) the number of rows down from the top of the host
%     matrix at which the upper left pixel of the number 1 will appear. 
%     May be negative (in which case, the upper left pixel will be chopped 
%     off).
%
% column_offset - (integer) the number of columns rightward of the left of
%     the host matrix at which the upper left pixel of the number 1 will 
%     appear. May be negative (in which case, the upper left pixel will be
%     chopped off).
%
% host_matrix_size - (positive integer) the width and height of the matrix
%     being returned into which the image of the 1 has been embedded
%
% fraction_noise - (real number between 0 and 1 inclusive) the fraction of
%     the bits in the final matrix that will be flipped prior to its being
%     returned. 0 is noiseless. 1 is the inverse. 0.3 means each bit has a
%     30% chance of being flipped.
%
% ------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------
%
% shifted_1_vector - the matrix reshaped into a row-vector - perfect for
%     adding as a row of some input data to some scientific dimensionality
%     reduction method.
%
%
%
% ------------------------------------------------------------------------
% Examples
% ------------------------------------------------------------------------
%
% [~,m]=shifted_1(0,0,13,0)
% 
% m =
% 
%   Columns 1 through 11
% 
%      0     0     0     1     1     0     0     0     0     0     0
%      0     0     1     1     1     0     0     0     0     0     0
%      0     1     1     1     1     0     0     0     0     0     0
%      1     1     0     1     1     0     0     0     0     0     0
%      0     0     0     1     1     0     0     0     0     0     0
%      0     0     0     1     1     0     0     0     0     0     0
%      0     0     0     1     1     0     0     0     0     0     0
%      0     0     0     1     1     0     0     0     0     0     0
%      0     0     0     1     1     0     0     0     0     0     0
%      0     0     0     1     1     0     0     0     0     0     0
%      1     1     1     1     1     1     1     1     0     0     0
%      1     1     1     1     1     1     1     1     0     0     0
%      0     0     0     0     0     0     0     0     0     0     0
% 
%   Columns 12 through 13
% 
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0
%      0     0

assert(row_offset == round(row_offset));
assert(column_offset == round(column_offset));
assert(host_matrix_size == round(host_matrix_size));
assert(host_matrix_size > 0);
assert(fraction_noise >= 0);
assert(fraction_noise <= 1);

% Create the 1

raw_1 = [ ...
    0 0 0 1 1 0 0 0
    0 0 1 1 1 0 0 0
    0 1 1 1 1 0 0 0
    1 1 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1
    ];

% Paint the 1 into the matrix

shifted_1_matrix = zeros(host_matrix_size);
for i = 1:size(raw_1,1)
    for j = 1:size(raw_1,2)
        if(i + row_offset >= 1 && i + row_offset <= host_matrix_size && ...
           j + column_offset >= 1 && j + column_offset <= host_matrix_size)
           shifted_1_matrix(i+row_offset, j+column_offset) = raw_1(i,j);
        end
    end
end

% Flip the bits

should_flip = rand(size(shifted_1_matrix)) <= fraction_noise;
shifted_1_matrix(should_flip) = 1-shifted_1_matrix(should_flip);

% Reshape into a vector
shifted_1_vector = reshape(shifted_1_matrix, [], 1);

end

