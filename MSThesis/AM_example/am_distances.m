function rv = am_distances(am, mm)
% Return distances from points in a matrix to points in m_matrix
%
% All distances within the same letter are marked as don't cares (except
% for self-distances because matlab uses this to distinguish between sim
% and dissim matrices)
%
% This is from the A-M example on page 297 of Modern Multidimensional
% Scaling.
%
% am - (x by 2 matrix) abbreviation for a-matrix: the matrix for the points in the letter 'A'
%
% mm - (x by 2 matrix) abbreviation for m-matrix: the matrix for the points in the letter 'M'
% 


% Calculate the number of points forming each letter
num_a = size(am,1);
num_m = size(mm,1);

% Store the offset to add to the individual matrices row numbers to get the
% global point number
a_offset = 0;
m_offset = num_a;

rv = nan(num_a+num_m);
for a_row = 1:num_a
    a_index = a_row + a_offset;
    a = am(a_row,:);
    for m_row = 1:num_m
        m_index = m_row + m_offset;
        m = mm(m_row,:);
        d = norm(a-m);
        rv(a_index, m_index) = d;
        rv(m_index, a_index) = d;
    end
end

for i=1:size(rv,1)
    rv(i,i)=0;
end

end

