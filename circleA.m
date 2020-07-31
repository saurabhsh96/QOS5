% Plotting circles %Credits to mathwork website
function h = circleA(x,y,r)
    d = r*2;
    px = x-r;
    py = y-r;
    h = rectangle('Position',[px py d d],'Curvature',[1,1], 'LineWidth', ...
        1.5, 'EdgeColor',rand(1,3));
    daspect([1,1,1])
end