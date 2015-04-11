function [ direction ] = getDirectionFromIdentifer( id )
% Return direction string for identifier
switch id
    case 1
        direction = 'north'; 
    case 2
        direction = 'east';
    case 3
        direction = 'south';
    case 4
        direction = 'west';
end
end