function [ iObj ] = set_image( imageName, axes, width )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    data = imread(imageName);
    iObj = image(data, 'Parent', axes);
    
    [h, w, d] = size(data);
    
    set(axes, 'Units', 'Pixel', 'Position', [0, 0, width, width*h/w]);
    set(axes, 'Visible', 'off');

end

