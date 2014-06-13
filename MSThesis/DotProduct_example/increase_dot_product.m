function [ newa, newb] = increase_dot_product( a, b, learning_rate )
% Increases the dot product between a and b along the gradient
% 
% Return newa and newb that should replace a and b but have a higher dot
% product
%
% a - vector (same size as b)
%
% b - vector (same size as a)
%
% learning_rate - non-negative scalar indicating how aggressive to be in
%    changing the vectors.

newa = a+b*learning_rate;
newb = b+a*learning_rate;

end

