function [ iObj ] = set_image( imageName, axes, width)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    data = imread(imageName);
    iObj = image(data, 'Parent', axes);
    
    [h, w, d] = size(data);
    
    set(axes, 'Units', 'Pixel');
    currentPosition = get(axes, 'Position');
    currentWidth = currentPosition(3);
    if(width == 0)
        width = currentWidth;
    end
    
    set(axes, 'Units', 'Pixel', 'Position', [currentPosition(1), currentPosition(2), width, width*h/w]);
    set(axes, 'Visible', 'off');

end

