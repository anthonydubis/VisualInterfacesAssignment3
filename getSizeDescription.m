function [ size ] = getSizeDescription(buildingArea, minArea, maxArea)
% Return a human readable description of the size of the building
% Smallest, tiny, small, medium, large
% Tiny and small are meant to differentiate between the smaller buildings
% Medium and large will capture greater range segments

range_sz = (maxArea - minArea) / 6;

size = 'Medium in size';
if buildingArea == minArea 
    size = 'Smallest in size';
elseif buildingArea < (minArea + range_sz * .5)
    size = 'Tiny in size';
elseif buildingArea < (minArea + range_sz * 1.5)
    size = 'Small in size';
elseif buildingArea > (minArea + range_sz * 3.5)
    size = 'Large in size';
end

end

