function rv = a_matrix( )
%Return a matrix whose rows are the 2d points forma an A
%
% This is from the A-M example on page 297 of Modern Multidimensional
% Scaling. Row 1 is point 1 etc.

rv = [
    -7   1 % Left triangle part
    -6.5 2
    -6   3
    -5.5 4
    -5   5
    -4.5 6
    -4   7 % Right triangle part
    -3.5 6
    -3   5
    -2.5 4
    -2   3
    -1.5 2
    -1   1
    -5   4 % Cross-bar
    -4   4
    -3   4
    ];

end

