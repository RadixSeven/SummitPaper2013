function [num_pcs_without_rounding, num_pcs_with_rounding, error_with_rounding_including_up_to_pc, error_without_rounding_including_up_to_pc] = how_many_PCs_for_shifted_1( )
% Runs experiment looking at noisless reconstruction for shifted 1 to determine how many PC's SHOULD be extracted
%
% Creates 50000 shifted-1 entries in a 20x20 grid and extracts the
% principal components (and column means). Then creates 5000 more and 
% converts them to PCA space using the components from the first set. This 
% set is the 'selection' set. For each number n of components, it recreates 
% the selection set using the first n components and 2 algorithms. In the
% first, it just uses the components. In the second, it rounds (and
% truncates) to the set {0,1}. The mean error over all the pixels in all
% the elements of the selection set is recorded for each reconstruction
% method.
%
% For each method, the number of principal components with the best
% noiseless reconstruction is chosen.
%
% Finally, creates another 5000 and tests and reports how good the
% noiseless reconstruction with that algorithm and the given number of 
% components.
%
% ------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------
%
% num_pcs_without_rounding - (positive integer) the number of pcs that gave 
%     the best error when the reconstruction was not rounded
%
% num_pcs_with_rounding - (positive integer) the number of pcs that gave 
%     the best error when the reconstruction included rounding
%
% error_with_rounding_including_up_to_pc - (row vector) 
%     error_with_rounding_including_up_to_pc(i) is the mean error over the
%     entire selection set when i principal components were used and
%     rounding was included in the reconstruction method.
%
% error_without_rounding_including_up_to_pc - (row vector) 
%     error_with_rounding_including_up_to_pc(i) is the mean error over the
%     entire selection set when i principal components were used and
%     rounding was included in the reconstruction method.

fprintf('Generating coefficients\n');
coeff_data = shifted_1_dataset(50000,20,66598278);
coeff=princomp(coeff_data);
col_means = mean(coeff_data);


fprintf('Generating selection dataset\n');
[sel_data,sel_noiseless] = shifted_1_dataset(5000,20,46561034);
sel_scores = (sel_data - repmat(col_means,size(sel_data,1),1)) * coeff;

fprintf('Testing error for pc: ');
num_pcs_without_rounding = 1;
num_pcs_without_rounding_err = inf;
num_pcs_with_rounding = 1;
num_pcs_with_rounding_err = inf;

error_without_rounding_including_up_to_pc = zeros(1,size(coeff,2));
error_with_rounding_including_up_to_pc = zeros(1,size(coeff,2));

for num_pcs = 1:size(coeff, 2)
    if mod(num_pcs, 20) == 0
        fprintf(' %d', num_pcs);
    end
    [without, with] = reconstruction(num_pcs, sel_scores, coeff, col_means);
    
    e_with = reconstruction_error(with, sel_noiseless);
    error_with_rounding_including_up_to_pc(num_pcs)  = e_with;
    
    e_without = reconstruction_error(without, sel_noiseless);
    error_without_rounding_including_up_to_pc(num_pcs) = e_without;
    
    if e_with < num_pcs_with_rounding_err
        num_pcs_with_rounding = num_pcs;
        num_pcs_with_rounding_err = e_with;
    end
    
    if e_without < num_pcs_without_rounding_err
        num_pcs_without_rounding = num_pcs;
        num_pcs_without_rounding_err = e_without;
    end
end
fprintf('\n');

% Plot error vs PC
hold off;
h = zeros(2,1);
h(1) = plot(1:size(coeff, 2), error_with_rounding_including_up_to_pc,'r');
hold on;
h(2) = plot(1:size(coeff, 2), error_without_rounding_including_up_to_pc,'b');
title('Noiseless reconstruction error as a function of number of PCs');
legend(h,'With rounding','Without rounding');
xlabel('Number of principal components');
ylabel('Error of reconstruction compared with noiseless data');


fprintf('Optimal number of PCs with rounding: %d. Without rounding: %d\n', ...
    num_pcs_with_rounding, num_pcs_without_rounding);

fprintf('Generating test dataset\n');
[test_data,test_noiseless] = shifted_1_dataset(5000,20, 8985614);
test_scores = (test_data - repmat(col_means,size(test_data,1),1)) * coeff;

[without, ~] = reconstruction(num_pcs_without_rounding, test_scores, coeff, col_means);
[~, with] = reconstruction(num_pcs_with_rounding, test_scores, coeff, col_means);

fprintf('Test data gave errors of %.18g with rounding and %.18g without\n',...
    reconstruction_error(with, test_noiseless), ...
    reconstruction_error(without, test_noiseless));
end

