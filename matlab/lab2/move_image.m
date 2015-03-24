function move_image(axes, x, y)
%   Moves the image axes to position x and y, specified as relative
%   dimensions compared to the parent of axes. For example, x=0.5 y=0.5
%   will center axes on its parent.

    parent = get(axes, 'Parent');
    set(parent, 'Units', 'Pixel');
    parentPos = get(parent, 'Position');
    
    currentPos = get(axes, 'Position');
    
    set(axes, 'Units', 'Pixel');
    set(axes, 'Position', [parentPos(3)*x, parentPos(4)*y, currentPos(3), currentPos(4)]);


end

