%% Make the original simple data
%
% For the simple dataset, the original data is points evenly angularly
% distributed in two 30 degree segments on the surface of a unit circle,
% separated by 30 degrees. Note that the maximum difference between two
% points is less than 180 degrees, so the included angle is all that is
% important for the cosine (no wierd wrap-around effects).
points_per_cluster = 10;
simple_angles = ...
    [linspace(0,2*pi/12,points_per_cluster),...
    linspace(4*pi/12, 6*pi/12, points_per_cluster)]';
simple = [...
    cos(simple_angles), ...
    sin(simple_angles)];

%% Plot the original simple data
scatter(simple(:,1), simple(:,2));
xlim([0,1]); ylim([0,1]);

%% Perform MDS on the simple data
simple_scaled = mdscale(pdist(simple,'cosine'),2,'Criterion','metricstress');

%% Plot the MD scaled simple data
scatter(simple_scaled(:,1), simple_scaled(:,2));
xlim([-0.4,0.4]); ylim([-0.4,0.4]);

%% Make the radius-perturbed simple data
perturbed_radii = 1+round(rand(size(simple_angles)))/4;
perturbed = [...
    cos(simple_angles).*perturbed_radii, ...
    sin(simple_angles).*perturbed_radii];

%% Plot the perturbed data
scatter(perturbed(:,1),perturbed(:,2));
xlim([0,2]); ylim([0,2]);

%% Perform MDS on the perturbed data
perturbed_scaled = mdscale(pdist(perturbed,'cosine'),2,'Criterion','metricstress');

%% Plot the MD scaled perturbed data
scatter(perturbed_scaled(:,1),perturbed_scaled(:,2));
xlim([-0.4,0.4]); ylim([-0.4,0.4]);

%% Perform PCA on the simple and perturbed data
[simple_components,simple_scores] = princomp(simple);
[perturbed_components,perturbed_scores] = princomp(perturbed);

%% Plot the PCA'd simple data
scatter(simple_scores(:,1), simple_scores(:,2));
xlim([-0.8,0.8]); ylim([-0.8,0.8]);

%% Perform PCA on the MD scaled simple and perturbed data
[simple_scaled_components,simple_scaled_scores] = princomp(simple_scaled);
[perturbed_scaled_components,perturbed_scaled_scores] = princomp(perturbed_scaled);

%% Plot the PCA'd MD scaled simple data
scatter(simple_scaled_scores(:,1), simple_scaled_scores(:,2));
xlim([-0.4,0.4]); ylim([-0.4,0.4]);

%% Plot the PCA'd perturbed data
scatter(perturbed_scores(:,1), perturbed_scores(:,2));
xlim([-1,1]); ylim([-1,1]);

%% Plot the PCA'd MD scaled perturbed data
scatter(perturbed_scaled_scores(:,1), perturbed_scaled_scores(:,2));
xlim([-0.4,0.4]); ylim([-0.4,0.4]);
