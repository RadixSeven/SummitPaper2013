function [dataset, noiseless] = shifted_1_dataset( num_rows, shifted_1_side_size, seed, noise_type )
% Return a matrix whose rows are random shifted_1 instances
% 
% Does not affect the random number generator (restores the seed after it
% finishes)
% -------------------------------------------------------------------------
% Input
% -------------------------------------------------------------------------
% num_rows - (non-negative integer) the number of rows in the matrix to
%     return
%
% shifted_1_side_size - (positive integer) the length of a side of the
%     matrix into which the shifted 1s are embedded
%
% seed - (integer) the seed to use for the random number generator (must be
%   acceptable input to rng(sd))
%
% noise_type - (string) default 'bit flip' see the noise_type variable 
%   in shifted_1.m 
% -------------------------------------------------------------------------
% Output
% -------------------------------------------------------------------------
% dataset - (matrix) a num_rows x (shifted_1_side_size^2) matrix whose rows
%   are independently chosen shifted_1 instances and whose columns are 0 or
%   1 entries of the shifted_1 matrices
%
% noiseless - (matrix) same shifted_1 instances as dataset but without the
%   noise

% Set default noise type
if ~exist('noise_type','var')
    noise_type = 'bit flip';
end

% Check parameters
assert(num_rows == round(num_rows));
assert(num_rows >= 0)
assert(shifted_1_side_size > 0);
assert(shifted_1_side_size == round(shifted_1_side_size));
assert(seed==round(seed));
assert(strcmp(noise_type, 'bit flip') || strcmp(noise_type, 'gaussian'));


oldseed = rng(seed);

dataset = zeros(num_rows, shifted_1_side_size ^ 2);
noiseless = dataset;
for i=1:num_rows
    a = randi([-3, shifted_1_side_size-3]);
    b = randi([-3, shifted_1_side_size-3]);
    [dataset(i,:), noiseless(i,:)] = shifted_1(a,b,shifted_1_side_size,0.05,noise_type);
end

rng(oldseed);
end

