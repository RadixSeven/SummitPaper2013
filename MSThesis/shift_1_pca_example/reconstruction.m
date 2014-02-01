function [without_rounding, with_rounding]= reconstruction( num_components, scores, coeff, col_means )
% Reconstructs an original dataset from its pca scores using the first num_components of its principal components
% 
% ------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------
%
% num_components - (positive integer) the number of components to use in
%     the reconstruction. Columns 1:num_components will be used
%
% scores - (matrix) the coefficients of the points to reconstruct in the
%     PCA space represented by coeff and col_means. The scores for a given
%     point are in the rows.
%
% coeff - (matrix) the matrix of principal components. Each component is in
%     a column.
%
% col_means - (row vector) the means of the columns that are subtracted
%     from the original data before rotating when generating the PCA
%     coefficients and scores
%
% ------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------
%
% without_rounding - the plain reconstruction from multiplying the scores
%     by the components, summing, and adding the column means
%
% with_rounding - the without_rounding scores limited to the set {0,1} by
%     choosing which is closer to the unrounded value.
c = coeff(:,1:num_components);
without_rounding = (scores(:,1:num_components) * c') + repmat(col_means,size(scores,1),1);

with_rounding = without_rounding;
with_rounding(with_rounding < 0) = 0;
with_rounding(with_rounding > 1) = 1;
with_rounding = round(with_rounding);


end

