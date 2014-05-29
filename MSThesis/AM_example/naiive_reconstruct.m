function [recon, recon_error] = naiive_reconstruct( am, mm, initial_value_and_bounds )
% Function minimization attempt to reconstruct am and mm from their distance matrix
%
% am - the a-matrix containing coordinates of the points in the 'A'
%
% mm - the m-matrix containing coordinates of the points in the 'M'
%
% initial_value_and_bounds - a string indicating what sort of
%     initialization the optimization routine will get
%
%     'no-bounds-stdrnd' - upper and lower bounds of the optimization are
%         unset and x0 is uniform in [0,1]^n hyper-rectangle
%
%     'no-bounds-maxidst' - upper and lower bounds of the optimization are
%         unset and x0 is uniform in the hyper-rectangle [0,q]^n where
%         q is max_distance*num_points and max_distance is the maximum
%         distance between any point in am and any point in mm. In my
%         experiments, this gave excellent results - working whether
%         A and M overlapped or were completely disjoint. It took quite a
%         while to converge, however.
%
%     'no-bounds-point-max-min' - upper and lower bounds of the 
%         optimization are unset and x0 is formed by choosing the x values 
%         uniformly between the minimum and maximum x values of any point 
%         in the am and mm matrices and the y values similarly.
%
%
%     'matrix-dep-bounds-and-init-value' - upper and lower bounds of the 
%         optimization are the bounds for the rectangle containing the
%         points for the given letter in which the predicted point sits.
%         The points are chosen uniformly within those bounds.
%
% recon - the reconstructed points. recon(i,:) corresponds to the i'th row
%     in [am;mm]
%
% recon_error - the error value at the given reconstruction (the 2-norm of
%     the difference between the distance matrix of the reconstructed
%     points and the distance matrix of the original points)

% Calculate the number of points forming each letter
num_a = size(am,1);
num_m = size(mm,1);

% Calculate the true distances
true_distances = distance_calc([am;mm], num_a, num_m);

% Default bounds are unset
ub = [];
lb = [];
if strcmpi(initial_value_and_bounds,'no-bounds-maxidst')
    % Calculate the bounds for initial point set - no point can be farther
    % from another than the maximum distance times the number of points
    % This is a very sloppy bound, I could make it much tighter.
    maxdist=(num_a+num_m)*max(max(true_distances));

    % Generate the initial point set uniformly within the bounds
    x0 = rand(num_a+num_m, 2);
    x0(:,1) = x0(:,1).*maxdist;
    x0(:,2) = x0(:,2).*maxdist;

% Use the information about the locations of the am and mm
% points to try and reduce ambiguity.
elseif strcmpi(initial_value_and_bounds,'matrix-dep-bounds-and-init-value')
    x0 = rand(num_a+num_m, 2);
    
    minax=min(am(:,1));
    maxax=max(am(:,1));
    minay=min(am(:,2));
    maxay=max(am(:,2));

    x0(1:num_a,1) = x0(1:num_a,1).*(maxax-minax);
    x0(1:num_a,1) = x0(1:num_a,1) + minax;
    x0(1:num_a,2) = x0(1:num_a,2).*(maxay-minay);
    x0(1:num_a,2) = x0(1:num_a,2) + minay;
    
    
    
    minmx=min(mm(:,1));
    maxmx=max(mm(:,1));
    minmy=min(mm(:,2));
    maxmy=max(mm(:,2));
    
    x0(num_a+1:num_a+num_m,1) = x0(num_a+1:num_a+num_m,1).*(maxmx-minmx);
    x0(num_a+1:num_a+num_m,1) = x0(num_a+1:num_a+num_m,1) + minmx;
    x0(num_a+1:num_a+num_m,2) = x0(num_a+1:num_a+num_m,2).*(maxmy-minmy);
    x0(num_a+1:num_a+num_m,2) = x0(num_a+1:num_a+num_m,2) + minmy;

    lb = x0;
    lb(1:num_a,1)=minax;
    lb(1:num_a,2)=minay;
    lb(num_a+1:num_a+num_m,1)=minmx;
    lb(num_a+1:num_a+num_m,2)=minmy;

    ub = x0;
    ub(1:num_a,1)=maxax;
    ub(1:num_a,2)=maxay;
    ub(num_a+1:num_a+num_m,1)=maxmx;
    ub(num_a+1:num_a+num_m,2)=maxmy;
else
    error('naiive_reconstruct:bad_initialvalueandbounds',...
        ['Invalid value "' initial_value_and_bounds '" given for ' ...
        'initial_value_and_bounds']);
end

% Calculate the reconstruction by minimizing the error function err
[recon,recon_error] = lsqnonlin(@err, x0,lb,ub,...
    optimset('MaxFunEvals',(num_a+num_m)*2*10000,'MaxIter',4000,...
    'PlotFcns',@optimplotresnorm,'TolFun',0,'TolX',1e-14));

    function e=err(points)
    % Return the error between the distances in the two sets of
    % points in points (of size num_a and num_m) and the true 
    % distances
        these_dist = distance_calc(points, num_a, num_m);
        e=reshape(true_distances-these_dist,[],1);
    end

    function d=distance_calc(points, num1, num2)
    % Calculate the distances between two sets of points in the
    % matrix points. The first set is points(1:num1,:) and the second
    % set is points(num1+1:num1+num2,:). d(i,j) is the distance between
    % the i'th point in the first set and the j'th point in the second
    % set.
        d = nan(num1,num2);
        for i=1:num1
            for j=1:num2
                d(i,j)=norm(points(i,:)-points(num1+j,:));
            end
        end
    end

end

