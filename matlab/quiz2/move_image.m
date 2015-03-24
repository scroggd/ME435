function [ image ] = move_image( image, x, y )
%MOVE_IMAGE Summary of this function goes here
%   Detailed explanation goes here
    
    current = get(image, 'Position');
    set(image, 'Position', current + [x, y, 0, 0]);
    fprintf('hi')


end

