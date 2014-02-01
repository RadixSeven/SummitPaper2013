function err = reconstruction_error( reconstructed , expected )
% Returns sqrt(sum(reconstructed-expected).^2))/numel(expected)
%
% ------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------
%
% reconstructed - (matrix) the matrix whose difference is being evaluated
%
% expected - (matrix same size as reconstructed) expected vaue of
%     reconstructed
%
% ------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------
%
% err - the error between the reconstructed and expected items

d = reshape((reconstructed-expected).^2,[],1);
err = sqrt(sum(d))/numel(expected);

end

