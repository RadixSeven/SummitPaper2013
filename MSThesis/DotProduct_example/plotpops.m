function figure_handle = plotpops( a, b, group_size )
% Plot the populations a and b on a new figure and return its handle
assert(size(a,1)==size(b,1));

figure_handle = figure;
hold on;
specs={'ro','go','bo','co','mo','yo','ko'};
spec_index = 1;

for lb = 1:group_size:size(a,1)
    ub = min(lb+group_size-1,size(a,1));
    scatter(a(lb:ub,1), a(lb:ub,2), specs{spec_index});
    scatter(b(lb:ub,1), b(lb:ub,2), specs{spec_index}, 'filled');    
    spec_index = mod(spec_index, length(specs))+1;
end


end

