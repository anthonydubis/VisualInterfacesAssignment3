function [ size ] = getSizeDescription(buildingArea, minArea, maxArea)
% Return a human readable description of the size of the building
% Smallest, tiny, small, medium, large
% Tiny and small are meant to differentiate between the smaller buildings
% Medium and large will capture greater range segments

range_sz = (maxArea - minArea) / 6;

size = 'medium';
if buildingArea == minArea 
    size = 'smallest';
elseif buildingArea < (minArea + range_sz * .5)
    size = 'tiny';
elseif buildingArea < (minArea + range_sz * 1.5)
    size = 'small';
elseif buildingArea > (minArea + range_sz * 3.5)
    size = 'large';
end

end

