%% Set up points
num_per_cluster=250; % Number of points per cluster
separation = 4; % Separation of the cluster centers in terms of number of standard deviations
datacell = cell(2,2);
data=zeros(num_per_cluster*4,2);
cur_data = 1;
for i=1:2
    for j=1:2
        datacell{i,j}=randn(num_per_cluster,2)/separation+repmat([j,i],num_per_cluster,1);
        data(cur_data:cur_data+num_per_cluster-1,:)=datacell{i,j};
        cur_data = cur_data + num_per_cluster;
    end
end
clear cur_data i j;

%% Plot points
hold off;
for i=1:2
    for j=1:2
        c = datacell{i,j};
        scatter(c(:,1),c(:,2));
        hold on;
    end
end
hold off;
clear i j c;

%% Do conventional k-means
[~,centroids]=kmeans(data,4,'replicates',10,'options',statset('MaxIter',100+num_per_cluster/10));

%% Plot the means
hold on;
scatter(centroids(:,1), centroids(:,2), 'k+');
hold off;

%% Print the error
expected = [1,1;1,2;2,1;2,2];
sorted_centroids = centroids;
unsorted_centroids = centroids;
for sorted_idx = 1:size(sorted_centroids,1)-1
    cur_expected = expected(sorted_idx,:);
    errs = sum((unsorted_centroids - repmat(cur_expected,size(unsorted_centroids,1),1).^2),2);
    [~,best_match] = min(errs);
    sorted_centroids(sorted_idx,:) = unsorted_centroids(best_match,:);
    unsorted_centroids(best_match,:) = [];
end
assert(size(unsorted_centroids,1)==1);
sorted_centroids(end,:)=unsorted_centroids(1,:);

err=mean(sqrt(sum((sorted_centroids-expected).^2,2)));
hold on;
title(sprintf('Error: %f', err));
hold off;

clear errs cur_expected unsorted_centroids best_match err sorted_idx

%% Do 2 means getting 2 centroids
[~,c_2_1]=kmeans(data,2,'replicates',10,'options',statset('MaxIter',100+num_per_cluster/10));

%% Redo data in terms of distances from the two centroids
datacell_2_1 = datacell;
cur_data = 1;
for i=1:2
    for j=1:2
        for c_idx = 1:size(c_2_1,1)
            c_cur = c_2_1(c_idx,:);
            d_cur = datacell{i,j};
            datacell_2_1{i,j}(:,c_idx)=sum((d_cur - repmat(c_cur,size(d_cur,1),1).^2),2);
            data_2_1(cur_data:cur_data+num_per_cluster-1,:)=datacell_2_1{i,j};
            cur_data = cur_data + num_per_cluster;
        end
    end
end
clear cur_data i j c_cur d_cur;

%% Plot redone points
hold off;
for i=1:2
    for j=1:2
        c = datacell_2_1{i,j};
        scatter(c(:,1),c(:,2));
        hold on;
    end
end
hold off;
clear i j c;


%% Do 2 means again getting 2 centroids
[~,c_2_2]=kmeans(data_2_1,2,'replicates',10,'options',statset('MaxIter',100+num_per_cluster/10));

%% Redo data in terms of distances from the two centroids
datacell_2_2 = datacell_2_1;
cur_data = 1;
for i=1:2
    for j=1:2
        for c_idx = 1:size(c_2_2,1)
            c_cur = c_2_2(c_idx,:);
            d_cur = datacell_2_1{i,j};
            datacell_2_2{i,j}(:,c_idx)=sum((d_cur - repmat(c_cur,size(d_cur,1),1).^2),2);
            data_2_2(cur_data:cur_data+num_per_cluster-1,:)=datacell_2_2{i,j};
            cur_data = cur_data + num_per_cluster;
        end
    end
end
clear cur_data i j c_cur d_cur;

%% Plot redone points
hold off;
for i=1:2
    for j=1:2
        c = datacell_2_2{i,j};
        scatter(c(:,1),c(:,2));
        hold on;
    end
end
hold off;
clear i j c;


%% Do "deep learning"
%
% Note: the matlab k-means algorithm is VERY slow for high dimensions
datacell_cur = datacell;
data_cur = data;
datacell_all = {datacell};
num_dim = size(data,1)/2;
while(num_dim >= 2)
    fprintf(2,'Starting k-means for %d dimensions\n', num_dim);
    [~,c_cur] = kmeans(data_cur,num_dim,'replicates',10,'options',statset('MaxIter',100+num_per_cluster),'emptyaction','singleton');
    fprintf(2,'Done with k-means for %d dimensions. Starting projection.\n', num_dim);
    datacell_next = datacell_cur;
    data_next = zeros(size(data_cur,1),num_dim);
    cur_data = 1;
    for i=1:2
        for j=1:2
            datacell_next{i,j}=zeros(num_per_cluster, num_dim);
            for c_idx = 1:size(c_cur,1)
                cent = c_cur(c_idx,:);
                d_cur = datacell_cur{i,j};
                datacell_next{i,j}(:,c_idx)=sqrt(sum((d_cur - repmat(cent,size(d_cur,1),1)).^2,2));
                data_next(cur_data:cur_data+num_per_cluster-1,:)=datacell_next{i,j};
            end
            cur_data = cur_data + num_per_cluster;
        end
    end
    fprintf(2,'Done with projecting from %d -> %d dimensions.\n', size(data_cur,2), num_dim);
    
    datacell_cur = datacell_next;
    datacell_all{end+1} = datacell_next; %#ok<SAGROW>
    data_cur = data_next;
    num_dim = round(num_dim / 2);
end

%% Plot the final deep learning layer
hold off;
for i=1:2
    for j=1:2
        c = datacell_cur{i,j};
        scatter(c(:,1),c(:,2));
        hold on;
    end
end
hold off;
clear i j c;
