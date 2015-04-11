function [ id ] = getReverseDirectionIdentifier( direction )
% Returns the reverse integer identifier for a direction
% Useful when wording directions in certain ways
switch direction
    case 'north' 
        id = 3;
    case 'east'
        id = 4;
    case 'south' 
        id =  1;
    case 'west'
        id =  2;
end
end
