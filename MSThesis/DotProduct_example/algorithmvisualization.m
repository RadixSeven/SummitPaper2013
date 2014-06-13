function algorithmvisualization( )
% Makes (and saves to files in ../images) plots of the simplified learning algorithm organizing random vectors

% Set up initial populations of target and context vectors to zero and
% random vectors respectively
group_size = 9; 
num_groups = 5;
a=rand(num_groups*group_size,2)-0.5; 
b=zeros(num_groups*group_size,2); 

% Plot the initial population
plot_population(0);

% Do 2000 iterations of the algorithm, stopping every hundred iterations to
% display the population
iterations_between_plots = 100;
num_plots = 45;
total_iterations = num_plots*iterations_between_plots;
for i=1:total_iterations
    [a,b]=learn_1_cycle(a,b,gen_event(size(a,1),group_size), 0.1); 
    if mod(i,iterations_between_plots)==0
        plot_population(i);
    end
end;


    function plot_population(iteration_number)
        fig_handle = plotpops(a,b,group_size);
        title(sprintf('Population after %d iterations',iteration_number));
        filename=sprintf('../images/algorithmvisualization_%05d.png', ...
            iteration_number);
        print(fig_handle, filename, '-dpng','-r300');
        close(fig_handle);
    end
end
