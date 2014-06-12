function dotproductvisualization( )
% Create a new figure with a visualization of the dot product and save it
% to '../images/dotproductvisualization.png'

origin=[0 0 0];

downalittle=[0 0 -0.5];
leftalittle=[-0.25 0 0];

b=[5 5 0];
btext=b/2+downalittle;
bcolor=[0.85 0.85 0];


a=[-1 5 0];
atext=a/2+downalittle;
acolor=[0.75 0   0];

theta=abs(atan2(a(2),a(1))-atan2(b(2),b(1))); %Assumes 2d a and b

rectcolor=[0.85 0.5 0];
bup=norm(b).*[0 0 1];
buptext = 3*bup/4+leftalittle;
aproj=(b./norm(b))*(norm(a)*cos(theta));
aprojtext=aproj/2+downalittle;
recttext = aproj/2+bup/2;

fighandle=figure;
axis([-2.5 5 -1 5 -1 7 0 1]);
view(-8,26);
mArrow3(origin, a, 'color', acolor, 'stemWidth', 0.05);
mArrow3(origin, b, 'color', bcolor, 'stemWidth', 0.05);
mArrow3(origin, aproj, 'color', rectcolor, 'facealpha', 1.0, ...
    'stemWidth', 0.06);
mArrow3(origin, bup,   'color', rectcolor, 'facealpha', 1.0, ...
    'stemWidth', 0.06);
patch([origin(1) origin(1) aproj(1) aproj(1)], ...
      [origin(2) origin(2) aproj(2) aproj(2)], ...
      [origin(3) bup(3)    bup(3)   aproj(3)], ...
      [1 1 1 1], 'facealpha', 0.5,'FaceColor',rectcolor);
text(atext(1),atext(2),atext(3),'A',...
    'HorizontalAlignment','Center','VerticalAlignment','Top');
text(btext(1),btext(2),btext(3),'B',...
    'HorizontalAlignment','Center','VerticalAlignment','Top');
text(buptext(1),buptext(2),buptext(3),'B perpendicular',...
    'HorizontalAlignment','Right','VerticalAlignment','Middle');
text(aprojtext(1),aprojtext(2),aprojtext(3),'A proj',...
    'HorizontalAlignment','Center','VerticalAlignment','Top');
text(recttext(1),recttext(2),recttext(3),'A \cdot B',...
    'HorizontalAlignment','Center','VerticalAlignment','Middle');
line('LineStyle','--',...
    'XData', [a(1) aproj(1)],...
    'YData', [a(2) aproj(2)],...
    'ZData', [a(3) aproj(3)],...
    'Color', [0 0 0]);

title('Visualization of the Dot Product');
grid on;
light('Position',[1 0 0],'Style','infinite');
light('Position',[-1 1 0],'Style','infinite');
axis vis3d;

print(fighandle, '../images/dotproductvisualization.png', '-dpng','-r300');
end

