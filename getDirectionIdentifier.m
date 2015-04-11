function [ id ] = getDirectionIdentifier( direction )
% Returns an integer identifier for a direction
switch direction
    case 'north' 
        id = 1;
    case 'east'
        id = 2;
    case 'south' 
        id =  3;
    case 'west'
        id =  4;
end
end

