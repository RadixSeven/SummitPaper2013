function dotproductaugmentation( )
% Create a new figure with a visualization of the dot product being
% increased and save it to '../images/dotproductvisualization.png'

origin=[0 0 0];

downalittle=[0 0 -0.5];
leftalittle=[-0.125 0 0];

b=[5 5 0];
btext=b/2+downalittle-leftalittle;

a=[-1 5 0];
atext=a/2+downalittle+leftalittle;

adelta = b/3;
adeltatext=a+adelta/3-downalittle+3*leftalittle/4;
bdelta = a/3;
bdeltatext=b+bdelta/3+leftalittle;

achanged = a+adelta;
achangedtext = achanged/2-leftalittle;
bchanged = b+bdelta;
bchangedtext = 2*bchanged/3+5*leftalittle/4;

arcstarttheta = atan2(bchanged(2),bchanged(1));
arcendtheta = atan2(achanged(2), achanged(1));
arcthetas=linspace(arcstarttheta, arcendtheta, 100);
arcx=1.5*cos(arcthetas);
arcy=1.5*sin(arcthetas);
arctext=[arcx(40) arcy(40) 0]-downalittle-leftalittle;
arctextangle = arcthetas(40)*180/pi;

original_color=[0.75 0 0];

augment_color=[0.2 0.45 0.21];

final_color=[0 0 0.75];

fighandle=figure;
axis([-1.5 5.5 -1 8]);
axis square;
mArrow3(origin, a, 'color', original_color, 'stemWidth', 0.05);
mArrow3(origin, b, 'color', original_color, 'stemWidth', 0.05);

mArrow3(a, achanged, 'color', augment_color , 'facealpha', 1.0, ...
    'stemWidth', 0.05);
mArrow3(b, bchanged, 'color', augment_color , 'facealpha', 1.0, ...
    'stemWidth', 0.05);

mArrow3(origin, achanged, 'color', final_color , 'facealpha', 1.0, ...
    'stemWidth', 0.05);
mArrow3(origin, bchanged, 'color', final_color , 'facealpha', 1.0, ...
    'stemWidth', 0.05);


text(atext(1),atext(2),atext(3),'A',...
    'HorizontalAlignment','Right','VerticalAlignment','Top');
text(btext(1),btext(2),btext(3),'B',...
    'HorizontalAlignment','Left','VerticalAlignment','Top');
text(achangedtext(1),achangedtext(2),achangedtext(3),'A + \Delta{}A',...
    'HorizontalAlignment','Left','VerticalAlignment','Middle');
text(bchangedtext(1),bchangedtext(2),bchangedtext(3),'B + \Delta{}B',...
    'HorizontalAlignment','Right','VerticalAlignment','Middle');
text(adeltatext(1),adeltatext(2),adeltatext(3),'\Delta{}A',...
    'HorizontalAlignment','Right','VerticalAlignment','Bottom');
text(bdeltatext(1),bdeltatext(2),bdeltatext(3),'\Delta{}B',...
    'HorizontalAlignment','Right','VerticalAlignment','Middle');

line('XData',arcx, 'YData', arcy, 'LineStyle', '--');
text(arctext(1), arctext(2), arctext(3), 'Smaller angle', ...
    'HorizontalAlignment','Left','VerticalAlignment','Bottom', ...
    'Rotation', arctextangle);

title('Visualization of Increasing Dot Product');
grid on;


print(fighandle, '../images/dotproductaugmentation.png', '-dpng','-r300');
end

