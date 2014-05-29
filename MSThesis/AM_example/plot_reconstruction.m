function plot_reconstruction( recon )
% Plot a reconstruction of the AM problem from distances given by am_distances
%
% The A points (entries 1:16) are plotted in red and the M points
% (entries 17:35) are plotted in blue

hold off; 
scatter(recon(1:16,1),recon(1:16,2),'r');
hold on; 
plot(recon(1:13,1),recon(1:13,2),'r'); % Legs of A
plot(recon([4,14:16,10],1),recon([4,14:16,10],2),'r'); % Crossbar of A

scatter(recon(17:end,1),recon(17:end,2),'b'); 
plot(recon(17:end,1),recon(17:end,2),'b');

hold off

end

