function twovarsoftmax( )
% Plots the two-variable softmax function for a figure in my thesis and saves it to the png 'images/twovarsoftmax.png'

if ~exist('images','dir')
    error('The images directory where the plot will be written must exist.');
end

fig=figure;
[x,y]=meshgrid(-4:0.1:4,-4:0.1:4);
z=exp(x)./(exp(x)+exp(y));

surf(x,y,z);
xlabel('x'); ylabel('y'); zlabel('P(x)');
title('Probability of x after the softmax function');
view(-80,30);
print(fig,'-dpng','-r300','images/twovarsoftmax.png');
end

